extends Node3D

@onready var player: Node = $Player
@onready var cargo: RigidBody3D = $Cargo
@onready var failure_overlay: Control = $HUD/FailureOverlay
@onready var result_title: Label = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/Title
@onready var result_message: Label = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/Message
@onready var retry_button: Button = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/RetryButton
@onready var finish_zone: Area3D = $FinishZone

var _run_over := false
var _restart_queued := false

func _ready() -> void:
	failure_overlay.hide()
	player.connect("cargo_dropped", _on_cargo_dropped)
	retry_button.pressed.connect(_restart_run)
	finish_zone.body_entered.connect(_on_finish_zone_body_entered)

func _process(_delta: float) -> void:
	if _run_over:
		return

	if not is_instance_valid(cargo):
		_show_end_screen(false)
		return

	if cargo.global_position.y < -1.0 or absf(cargo.global_position.x) > 8.0 or absf(cargo.global_position.z) > 25.0:
		_show_end_screen(false)

func _unhandled_input(event: InputEvent) -> void:
	if not _run_over:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_R:
		_restart_run()

func _on_cargo_dropped() -> void:
	_show_end_screen(false)

func _on_finish_zone_body_entered(body: Node3D) -> void:
	if body == player:
		_show_end_screen(true)

func _show_end_screen(completed: bool) -> void:
	if _run_over:
		return

	_run_over = true
	if completed:
		result_title.text = "Parkur tamamlandı!"
		result_message.text = "Koliyi sağlam ulaştırdın."
		retry_button.text = "Tekrar oyna (R)"
	else:
		result_title.text = "Koli düştü!"
		result_message.text = "Koli taşıma noktasından ayrıldı ya da parkurdan düştü. Yeniden dene."
		retry_button.text = "Yeniden dene (R)"
	failure_overlay.show()
	player.set_physics_process(false)
	player.set("velocity", Vector3.ZERO)

func _restart_run() -> void:
	if _restart_queued:
		return

	_restart_queued = true
	get_tree().call_deferred("reload_current_scene")
