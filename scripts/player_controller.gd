extends CharacterBody3D

signal cargo_dropped

@export_range(0.1, 20.0, 0.1) var move_speed: float = 5.0
@export_range(1.0, 50.0, 0.5) var gravity_strength: float = 20.0
@export var cargo_path: NodePath = NodePath("../Cargo")
@export_range(1.0, 15.0, 0.5) var cargo_sudden_movement_threshold: float = 6.5

@onready var carry_anchor: RigidBody3D = $CarryAnchor
@onready var carry_joint: PinJoint3D = $CarryJoint
@onready var extended_arm: MeshInstance3D = $ExtendedArm
@onready var hand: MeshInstance3D = $Hand

var _cargo: RigidBody3D
var _cargo_is_attached := true
var _previous_target_velocity := Vector3.ZERO

func _ready() -> void:
	call_deferred("_connect_cargo")

func _connect_cargo() -> void:
	_cargo = get_node_or_null(cargo_path) as RigidBody3D
	if _cargo == null:
		push_warning("Taşınacak koli bulunamadı: %s" % cargo_path)
		_cargo_is_attached = false
		return

	add_collision_exception_with(_cargo)
	add_collision_exception_with(carry_anchor)
	carry_joint.node_a = carry_anchor.get_path()
	carry_joint.node_b = _cargo.get_path()
	if not _cargo.body_entered.is_connected(_on_cargo_body_entered):
		_cargo.body_entered.connect(_on_cargo_body_entered)

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	var movement_direction := Vector3(input_vector.x, 0.0, input_vector.y)

	if movement_direction.length_squared() > 1.0:
		movement_direction = movement_direction.normalized()

	var target_velocity := movement_direction * move_speed
	if _cargo_is_attached and (target_velocity - _previous_target_velocity).length() >= cargo_sudden_movement_threshold:
		_drop_cargo()
	_previous_target_velocity = target_velocity
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z

	if is_on_floor():
		if velocity.y < 0.0:
			velocity.y = 0.0
	else:
		velocity.y -= gravity_strength * delta

	if Input.is_action_just_pressed("drop_cargo"):
		_drop_cargo()

	var incoming_velocity := velocity
	move_and_slide()
	if _cargo_is_attached:
		for collision_index in get_slide_collision_count():
			var collision := get_slide_collision(collision_index)
			if collision.get_normal().y < 0.65 and incoming_velocity.dot(collision.get_normal()) < -2.0:
				_drop_cargo()
				break

func _on_cargo_body_entered(body: Node) -> void:
	if _cargo_is_attached and body != self and body != carry_anchor:
		_drop_cargo()

func _drop_cargo() -> void:
	if not _cargo_is_attached or not is_instance_valid(_cargo):
		return

	_cargo_is_attached = false
	extended_arm.hide()
	hand.hide()
	carry_joint.queue_free()
	_cargo.linear_velocity = velocity
	_cargo.apply_central_impulse(Vector3(0.0, -0.5, -1.0))
	_cargo.sleeping = false
	cargo_dropped.emit()






