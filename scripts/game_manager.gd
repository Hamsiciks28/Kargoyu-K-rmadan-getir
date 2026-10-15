extends Node3D

const DELIVERY_SCORE := 1000

@onready var player: Node = $Player
@onready var cargo: RigidBody3D = $Cargo
@onready var score_label: Label = $HUD/ScoreLabel
@onready var timer_label: Label = $HUD/TimerLabel
@onready var failure_overlay: Control = $HUD/FailureOverlay
@onready var result_title: Label = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/Title
@onready var result_message: Label = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/Message
@onready var retry_button: Button = $HUD/FailureOverlay/CenterContainer/Panel/VBoxContainer/RetryButton
@onready var start_zone: Area3D = $StartZone
@onready var finish_zone: Area3D = $FinishZone

var _run_started := false
var _run_over := false
var _restart_queued := false
var score := 0
var elapsed_seconds := 0.0

func _ready() -> void:
	score = 0
	elapsed_seconds = 0.0
	_update_score_display()
	_update_timer_display()
	failure_overlay.hide()
	player.connect("cargo_dropped", _on_cargo_dropped)
	retry_button.pressed.connect(_restart_run)
	start_zone.body_exited.connect(_on_start_zone_body_exited)
	finish_zone.body_entered.connect(_on_finish_zone_body_entered)

func _process(delta: float) -> void:
	if _run_over:
		return

	if _run_started:
		elapsed_seconds += delta
		_update_timer_display()

	if not is_instance_valid(cargo):
		_show_end_screen(false, "Koli sahneden kayboldu. Yeniden dene.")
		return

	if cargo.global_position.y < -1.0 or absf(cargo.global_position.x) > 8.0 or absf(cargo.global_position.z) > 25.0:
		_show_end_screen(false, "Koli parkurdan düştü. Rampaya girerken yavaşla.")

func _unhandled_input(event: InputEvent) -> void:
	if not _run_over:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_R:
		_restart_run()

func _on_cargo_dropped(reason: String) -> void:
	_show_end_screen(false, reason)

func _on_start_zone_body_exited(body: Node3D) -> void:
	if body != player or _run_started or _run_over:
		return
	_run_started = true

func _on_finish_zone_body_entered(body: Node3D) -> void:
	if body != player:
		return
	if _run_over or not is_instance_valid(player) or not is_instance_valid(cargo):
		return
	if not bool(player.get("_cargo_is_attached")):
		return
	_show_end_screen(true)

func _show_end_screen(completed: bool, failure_reason: String = "") -> void:
	if _run_over:
		return

	_run_over = true
	score = DELIVERY_SCORE if completed else 0
	_update_score_display()
	_update_timer_display()
	var time_summary := "Süre: %.1f sn" % elapsed_seconds
	if completed:
		result_title.text = "Parkur tamamlandı!"
		result_message.text = "Koliyi sağlam ulaştırdın.\n%s" % time_summary
		retry_button.text = "Tekrar oyna (R)"
	else:
		result_title.text = "Koli düştü!"
		var reason := failure_reason if not failure_reason.is_empty() else "Koli düştü. Yeniden deneyip hareketlerini yumuşat."
		result_message.text = "%s\n%s" % [reason, time_summary]
		retry_button.text = "Yeniden dene (R)"
	failure_overlay.show()
	player.set_physics_process(false)
	player.set("velocity", Vector3.ZERO)

func _update_score_display() -> void:
	score_label.text = "Skor: %d" % score

func _update_timer_display() -> void:
	timer_label.text = "Süre: %.1f sn" % elapsed_seconds

func _restart_run() -> void:
	if _restart_queued:
		return

	_restart_queued = true
	get_tree().call_deferred("reload_current_scene")
