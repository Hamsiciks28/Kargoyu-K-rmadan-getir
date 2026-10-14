extends Camera3D

@export var target_path: NodePath = NodePath("../Player")
@export var follow_offset: Vector3 = Vector3(0.0, 7.0, 10.0)
@export var look_offset: Vector3 = Vector3(0.0, 1.0, 0.0)
@export_range(0.1, 20.0, 0.1) var follow_speed: float = 5.0

var _target: Node3D

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node3D
	if _target == null:
		push_warning("Takip kamerası hedefini bulamadı: %s" % target_path)
		return

	global_position = _target.global_position + follow_offset
	look_at(_target.global_position + look_offset, Vector3.UP)

func _physics_process(delta: float) -> void:
	if _target == null:
		return

	var desired_position := _target.global_position + follow_offset
	var blend := 1.0 - exp(-follow_speed * delta)
	global_position = global_position.lerp(desired_position, blend)
	look_at(_target.global_position + look_offset, Vector3.UP)
