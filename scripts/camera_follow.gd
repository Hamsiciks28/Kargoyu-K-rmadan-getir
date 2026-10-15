extends Camera3D

@export var target_path: NodePath = NodePath("../Player")
@export var follow_offset: Vector3 = Vector3(0.0, 5.8, 6.8)
@export var look_offset: Vector3 = Vector3(0.0, 1.5, 0.0)
@export_range(0.1, 20.0, 0.1) var follow_speed: float = 3.0
@export_range(0.1, 20.0, 0.1) var rotation_speed: float = 3.2

var _target: Node3D

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node3D
	if _target == null:
		push_warning("Takip kamerası hedefini bulamadı: %s" % target_path)
		return

	global_position = _target.global_position + follow_offset
	var initial_look_target := _target.global_position + look_offset
	look_at(initial_look_target, Vector3.UP)

func _physics_process(delta: float) -> void:
	if _target == null:
		return

	# Ofset dünya yönünde sabit kalır; oyuncu döndüğünde kamera kendi etrafında dönmez.
	var desired_position := _target.global_position + follow_offset
	var desired_look_target := _target.global_position + look_offset
	var position_blend := 1.0 - exp(-follow_speed * delta)
	global_position = global_position.lerp(desired_position, position_blend)

	var desired_basis := Transform3D(Basis.IDENTITY, desired_position).looking_at(
		desired_look_target,
		Vector3.UP
	).basis
	var rotation_blend := 1.0 - exp(-rotation_speed * delta)
	global_basis = global_basis.slerp(desired_basis, rotation_blend)
