extends CharacterBody3D

signal cargo_dropped(reason: String)

@export_range(0.1, 20.0, 0.1) var move_speed: float = 5.0
@export_range(0.1, 20.0, 0.1) var sudden_move_speed: float = 9.0
@export_range(1.0, 50.0, 0.5) var gravity_strength: float = 20.0
@export var cargo_path: NodePath = NodePath("../Cargo")
@export_range(1.0, 2.5, 0.05) var cargo_sudden_movement_threshold: float = 1.7
@export_range(-1.0, 0.0, 0.05) var cargo_sudden_turn_dot: float = -0.85
@export_range(0.1, 1.0, 0.05) var cargo_direction_memory_window: float = 0.3
@export_range(1.0, 20.0, 0.5) var cargo_impact_drop_speed: float = 4.5
@export_range(1.0, 20.0, 0.5) var player_impact_drop_speed: float = 4.5
@export_range(1.0, 4.0, 0.1) var cargo_max_carry_separation: float = 2.0
@export var cargo_carry_offset := Vector3(0.0, 1.23, -1.1)

@onready var carry_anchor: RigidBody3D = $CarryAnchor
@onready var carry_joint: PinJoint3D = $CarryJoint
@onready var extended_arm: MeshInstance3D = $ExtendedArm
@onready var hand: MeshInstance3D = $Hand

var _cargo: RigidBody3D
var _cargo_is_attached := true
var _cargo_connection_pending := true
var _previous_target_velocity := Vector3.ZERO
var _previous_movement_direction := Vector3.ZERO
var _direction_memory_age := 0.0

func _ready() -> void:
	# Bu iki değer aynı olduğunda koli taşıma noktasıyla mafsalda hizalı kalır.
	carry_anchor.position = cargo_carry_offset
	carry_joint.position = cargo_carry_offset
	call_deferred("_connect_cargo")

func _connect_cargo() -> void:
	if not _cargo_connection_pending:
		return
	_cargo_connection_pending = false
	_cargo = get_node_or_null(cargo_path) as RigidBody3D
	if _cargo == null:
		push_warning("Taşınacak koli bulunamadı: %s" % cargo_path)
		_drop_cargo("Koli sahneden kayboldu. Yeniden dene.")
		return

	add_collision_exception_with(_cargo)
	add_collision_exception_with(carry_anchor)
	carry_joint.node_a = carry_anchor.get_path()
	carry_joint.node_b = _cargo.get_path()
	if not _cargo.body_entered.is_connected(_on_cargo_body_entered):
		_cargo.body_entered.connect(_on_cargo_body_entered)

func _physics_process(delta: float) -> void:
	# Taşıma bağlantısı call_deferred ile kurulurken ilk fizik adımı erken gelebilir.
	# Bağlantı tamamlanana kadar koli bütünlüğünü denetlemeyip yanlış düşüşü önle.
	if _cargo_connection_pending:
		return

	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	var movement_direction := Vector3(input_vector.x, 0.0, input_vector.y)

	if movement_direction.length_squared() > 1.0:
		movement_direction = movement_direction.normalized()

	var is_sudden_move := Input.is_action_pressed("sudden_move") and not movement_direction.is_zero_approx()
	var current_move_speed := sudden_move_speed if is_sudden_move else move_speed
	var target_velocity := movement_direction * current_move_speed
	var movement_change := (target_velocity - _previous_target_velocity).length()
	var sudden_movement_limit := move_speed * cargo_sudden_movement_threshold
	var previous_move_was_sudden := _previous_target_velocity.length() > move_speed + 0.01

	var is_sudden_turn := (
		not movement_direction.is_zero_approx()
		and not _previous_movement_direction.is_zero_approx()
		and _direction_memory_age <= cargo_direction_memory_window
		and movement_direction.dot(_previous_movement_direction) <= cargo_sudden_turn_dot
	)
	var sudden_speed_change := (
		not is_sudden_move
		and not previous_move_was_sudden
		and movement_change >= sudden_movement_limit
	)
	if _cargo_is_attached and is_sudden_turn:
		_drop_cargo("Koli dönüşte seni takip edemedi. Yönünü biraz daha yumuşak değiştir.")
	elif _cargo_is_attached and sudden_speed_change:
		_drop_cargo("Koli ani hızlanmada savruldu. Önce yavaşla, sonra hızlan.")
	_previous_target_velocity = target_velocity
	if not movement_direction.is_zero_approx():
		_previous_movement_direction = movement_direction
		_direction_memory_age = 0.0
	else:
		_direction_memory_age += delta
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z

	if is_on_floor():
		if velocity.y < 0.0:
			velocity.y = 0.0
	else:
		velocity.y -= gravity_strength * delta

	if Input.is_action_just_pressed("drop_cargo"):
		_drop_cargo("Koliyi sen bıraktın. Baştan deneyip dikkatlice taşı.")

	var incoming_velocity := velocity
	move_and_slide()
	if _cargo_is_attached:
		for collision_index in get_slide_collision_count():
			var collision := get_slide_collision(collision_index)
			if collision.get_normal().y < 0.65 and incoming_velocity.dot(collision.get_normal()) <= -player_impact_drop_speed:
				var collider := collision.get_collider()
				var impact_message := "Oyuncu engelle sert çarpıştı. Engellere daha yavaş yaklaş."
				if collider is Node and (collider as Node).is_in_group("cargo_drop_obstacle"):
					impact_message = "Engelle kafa kafaya geldin. Hızını biraz azalt."
				_drop_cargo(impact_message)
				break

	_check_cargo_carry_integrity()

func _check_cargo_carry_integrity() -> void:
	if not _cargo_is_attached:
		return

	if not is_instance_valid(_cargo):
		_drop_cargo("Koli sahneden kayboldu. Yeniden dene.")
		return

	if not is_instance_valid(carry_joint) or carry_joint.is_queued_for_deletion():
		_drop_cargo("Koli taşıma bağlantısı koptu. Yeniden dene.")
		return

	if _cargo.global_position.distance_to(carry_anchor.global_position) > cargo_max_carry_separation:
		_drop_cargo("Koli elinden fazla uzaklaştı. Hareketlerini yumuşat.")

func _on_cargo_body_entered(body: Node) -> void:
	if not _cargo_is_attached or body == self or body == carry_anchor:
		return

	var other_velocity := Vector3.ZERO
	if body is RigidBody3D:
		other_velocity = (body as RigidBody3D).linear_velocity
	elif body is CharacterBody3D:
		other_velocity = (body as CharacterBody3D).velocity

	var hit_course_obstacle := body.is_in_group("cargo_drop_obstacle")
	var direction_to_body := Vector3.ZERO
	if body is Node3D:
		direction_to_body = (_body_position(body) - _cargo.global_position).normalized()
	var cargo_approach_speed := (_cargo.linear_velocity - other_velocity).dot(direction_to_body)
	var player_approach_speed := (velocity - other_velocity).dot(direction_to_body)
	var impact_speed := cargo_approach_speed
	if hit_course_obstacle:
		impact_speed = maxf(impact_speed, player_approach_speed)
	if impact_speed >= cargo_impact_drop_speed:
		if hit_course_obstacle:
			_drop_cargo("Koli engelle sert çarpıştı. Biraz yavaşlayıp boşluktan geç.")
		else:
			_drop_cargo("Koli sert bir çarpışmayla elinden çıktı. Daha dikkatli ilerle.")

func _body_position(body: Node) -> Vector3:
	return (body as Node3D).global_position if body is Node3D else _cargo.global_position

func _drop_cargo(reason: String) -> void:
	if not _cargo_is_attached:
		return

	_cargo_is_attached = false
	extended_arm.hide()
	hand.hide()
	if is_instance_valid(carry_joint) and not carry_joint.is_queued_for_deletion():
		carry_joint.queue_free()
	if is_instance_valid(_cargo):
		_cargo.linear_velocity = velocity
		_cargo.apply_central_impulse(Vector3(0.0, -0.5, -1.0))
		_cargo.sleeping = false
	cargo_dropped.emit(reason)






