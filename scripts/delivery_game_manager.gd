extends Node3D

const CARGO_SCENE: PackedScene = preload("res://scenes/boxes/standard_box.tscn")

@export var economy: DeliveryEconomy = DeliveryEconomy.new()

@onready var player: CharacterBody3D = $Player
@onready var cargo_stock: Marker3D = $Neighborhood/Truck/CargoStock
@onready var truck_start_zone: Area3D = $Neighborhood/Truck/TruckStartZone
@onready var target_label: Label = $HUD/TargetLabel
@onready var package_label: Label = $HUD/PackageLabel
@onready var timer_label: Label = $HUD/TimerLabel
@onready var money_label: Label = $HUD/MoneyLabel
@onready var status_label: Label = $HUD/StatusLabel
@onready var result_overlay: Control = $HUD/ResultOverlay
@onready var result_title: Label = $HUD/ResultOverlay/Center/Panel/Content/Title
@onready var result_message: Label = $HUD/ResultOverlay/Center/Panel/Content/Message
@onready var restart_button: Button = $HUD/ResultOverlay/Center/Panel/Content/RestartButton

var delivery_points: Array[Area3D] = []
var cargo: RigidBody3D
var deliveries_done := 0
var earned_money := 0
var elapsed_seconds := 0.0
var run_started := false
var run_finished := false
var cargo_was_dropped := false
var drops_this_delivery := 0
var leg_started_at := 0.0
var restart_queued := false

func _ready() -> void:
	var scene_points := get_tree().get_nodes_in_group("delivery_point")
	scene_points.sort_custom(func(a: Node, b: Node) -> bool:
		return int(a.get_meta("order_index")) < int(b.get_meta("order_index"))
	)
	for point in scene_points:
		delivery_points.append(point as Area3D)

	if delivery_points.size() != 3:
		push_error("İlk mahallede üç teslimat noktası bulunmalı.")
		return
	truck_start_zone.body_exited.connect(_on_truck_start_zone_body_exited)
	restart_button.pressed.connect(_restart_run)
	player.connect("cargo_dropped", _on_cargo_dropped)
	result_overlay.hide()
	_spawn_cargo_at_truck()
	_update_target_markers()
	_update_hud()
	status_label.text = "Kamyon kasasındaki koliyi almak için E'ye bas."

func _process(delta: float) -> void:
	if run_finished:
		return
	if not run_started and player.call("has_attached_cargo") and not truck_start_zone.overlaps_body(player):
		_start_delivery_timer()
	if run_started:
		elapsed_seconds += delta
		_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact", false):
		if not run_finished:
			_interact()
			get_viewport().set_input_as_handled()
	elif event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_R and run_finished:
		_restart_run()

func _interact() -> void:
	if player.has_method("has_attached_cargo") and player.call("has_attached_cargo"):
		if _player_near_current_delivery():
			_deliver_cargo()
		else:
			status_label.text = "Sıradaki ev: %s. Teslimat işaretine yaklaş." % _current_address()
		return

	if not is_instance_valid(cargo):
		status_label.text = "Kamyonda alınacak koli yok."
		return
	var distance_to_cargo := _horizontal_distance(player.global_position, cargo.global_position)
	var can_collect := distance_to_cargo <= 3.1
	if not can_collect:
		status_label.text = "Koliyi almak için kamyona ya da yerdeki koliye yaklaş."
		return
	if player.call("attach_cargo", cargo):
		if cargo_was_dropped:
			status_label.text = "Koli yeniden alındı. Bu teslimatta 25 oyun parası ceza uygulanacak."
		else:
			status_label.text = "Koli alındı. Sıradaki hedefe git: %s" % _current_address()
		_update_hud()

func _player_near_current_delivery() -> bool:
	if deliveries_done >= delivery_points.size():
		return false
	return _horizontal_distance(player.global_position, delivery_points[deliveries_done].global_position) <= 2.35

func _deliver_cargo() -> void:
	var delivered := player.call("detach_cargo_for_delivery") as RigidBody3D
	if not is_instance_valid(delivered):
		return
	delivered.queue_free()

	var leg_seconds := maxf(elapsed_seconds - leg_started_at, 0.0)
	var reward_parts := economy.calculate_delivery_reward(leg_seconds, drops_this_delivery)
	var reward := int(reward_parts["total"])
	earned_money += reward
	deliveries_done += 1
	drops_this_delivery = 0
	leg_started_at = elapsed_seconds

	if deliveries_done >= delivery_points.size():
		_finish_run()
		return
	_spawn_cargo_at_truck()
	_update_target_markers()
	_update_hud()
	status_label.text = "Teslim edildi: +%d oyun parası. Sonraki koli kamyon kasasında." % reward

func _spawn_cargo_at_truck() -> void:
	cargo = CARGO_SCENE.instantiate() as RigidBody3D
	cargo.name = "CargoForStop%d" % (deliveries_done + 1)
	cargo.set_meta("target_order_index", deliveries_done)
	cargo.set_meta("target_address", _current_address())
	add_child(cargo)
	cargo.global_position = cargo_stock.global_position
	cargo_was_dropped = false

func _on_cargo_dropped(reason: String) -> void:
	cargo_was_dropped = true
	drops_this_delivery += 1
	status_label.text = "%s Koliyi yakından almak için E'ye bas; bu teslimatta 25 oyun parası ceza var." % reason
	_update_hud()

func _on_truck_start_zone_body_exited(body: Node3D) -> void:
	if body != player or run_started or run_finished:
		return
	if not player.call("has_attached_cargo"):
		return
	_start_delivery_timer()

func _start_delivery_timer() -> void:
	if run_started or run_finished:
		return
	run_started = true
	leg_started_at = elapsed_seconds
	status_label.text = "Süre başladı. Hedef: %s" % _current_address()
	_update_hud()

func _finish_run() -> void:
	run_finished = true
	_update_hud()
	result_title.text = "TUR TAMAMLANDI!"
	result_message.text = "Süre: %.1f saniye\nBaşarılı teslimat: %d / %d\nKazanılan para: %d" % [elapsed_seconds, deliveries_done, delivery_points.size(), earned_money]
	restart_button.text = "Tekrar oyna (R)"
	result_overlay.show()
	player.set_physics_process(false)
	player.set("velocity", Vector3.ZERO)

func _current_address() -> String:
	if deliveries_done >= delivery_points.size():
		return "Teslimatlar tamamlandı"
	return str(delivery_points[deliveries_done].get_meta("address"))

func _update_hud() -> void:
	if deliveries_done < delivery_points.size():
		target_label.text = "SIRADAKİ HEDEF %d / %d  •  %s" % [deliveries_done + 1, delivery_points.size(), _current_address()]
	else:
		target_label.text = "Bütün teslimatlar tamamlandı"
	package_label.text = "KOLİ: TAŞINIYOR" if player.call("has_attached_cargo") else ("KOLİ: YERDE" if cargo_was_dropped else "KOLİ: KAMYONDA")
	timer_label.text = "SÜRE  %.1f sn" % elapsed_seconds
	money_label.text = "PARA  %d" % earned_money

func _update_target_markers() -> void:
	for index in delivery_points.size():
		var point := delivery_points[index]
		var marker := point.get_node("Marker") as MeshInstance3D
		var material := StandardMaterial3D.new()
		material.albedo_color = Color("#20c9bd") if index == deliveries_done else Color("#79838b")
		material.roughness = 0.75
		marker.material_override = material
		(point.get_node("TargetSign") as Label3D).visible = index == deliveries_done

func _horizontal_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x, a.z).distance_to(Vector2(b.x, b.z))

func _restart_run() -> void:
	if restart_queued:
		return
	restart_queued = true
	get_tree().call_deferred("reload_current_scene")
