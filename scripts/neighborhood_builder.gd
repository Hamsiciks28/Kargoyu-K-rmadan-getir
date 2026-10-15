extends Node3D

const MOVING_BARRIER_SCRIPT: Script = preload("res://scripts/moving_barrier.gd")

const HOUSE_COLORS: Array[Color] = [
	Color("#f2ad56"),
	Color("#75b8cf"),
	Color("#dc8273"),
]
const ROOF_COLORS: Array[Color] = [
	Color("#b95d46"),
	Color("#5c7890"),
	Color("#d1a04e"),
]
const DELIVERY_Z := [7.0, -12.5, -40.5]
const DELIVERY_X := [-4.8, 4.8, -4.8]

func _ready() -> void:
	_build_street()
	_build_truck()
	_build_houses()
	_build_obstacles()
	_build_cones()
	_build_trees()
	_build_comedy_props()

func _material(color: Color, roughness := 0.9) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material

func _box(parent: Node3D, node_name: String, position: Vector3, size: Vector3, color: Color, collidable := false) -> Node3D:
	var container: Node3D
	if collidable:
		container = StaticBody3D.new()
	else:
		container = Node3D.new()
	container.name = node_name
	container.position = position
	parent.add_child(container)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	container.add_child(mesh_instance)
	if collidable:
		var shape_node := CollisionShape3D.new()
		shape_node.name = "CollisionShape3D"
		var shape := BoxShape3D.new()
		shape.size = size
		shape_node.shape = shape
		container.add_child(shape_node)
	return container

func _label(parent: Node3D, node_name: String, position: Vector3, text: String, color: Color, size := 40) -> Label3D:
	var label := Label3D.new()
	label.name = node_name
	label.position = position
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.text = text
	label.font_size = size
	label.pixel_size = 0.006
	label.outline_size = 6
	label.modulate = color
	parent.add_child(label)
	return label

func _build_street() -> void:
	_box(self, "Grass", Vector3(0, -0.12, -7), Vector3(50, 0.24, 84), Color("#7dbb72"), true)
	_box(self, "Road", Vector3(0, 0.02, -7), Vector3(12, 0.08, 84), Color("#515a64"), false)
	_box(self, "SidewalkLeft", Vector3(-7.15, 0.11, -7), Vector3(2.3, 0.2, 84), Color("#ded6c4"), false)
	_box(self, "SidewalkRight", Vector3(7.15, 0.11, -7), Vector3(2.3, 0.2, 84), Color("#ded6c4"), false)
	for marker_index in 18:
		var dash_z := 32.0 - float(marker_index) * 4.7
		_box(self, "RoadDash%02d" % marker_index, Vector3(0, 0.012, dash_z), Vector3(0.16, 0.025, 1.25), Color("#f2d875"))
	for side in [-1.0, 1.0]:
		_box(self, "Curb%02d" % int(side), Vector3(side * 5.95, 0.15, -7), Vector3(0.18, 0.3, 84), Color("#c4baaa"))

func _build_truck() -> void:
	var truck := Node3D.new()
	truck.name = "Truck"
	truck.position = Vector3(0, 0, 24)
	add_child(truck)
	_box(truck, "Chassis", Vector3(0, 0.65, 0), Vector3(2.8, 0.65, 6.2), Color("#2e77aa"))
	_box(truck, "Cab", Vector3(0, 1.75, -1.75), Vector3(2.8, 1.75, 2.6), Color("#358fc3"))
	_box(truck, "Windshield", Vector3(0, 2.05, -3.07), Vector3(2.35, 0.95, 0.06), Color("#a9dbea"))
	_box(truck, "Bumper", Vector3(0, 0.52, -3.16), Vector3(2.9, 0.22, 0.28), Color("#d8e1e5"))
	_box(truck, "CargoBed", Vector3(0, 1.12, 1.15), Vector3(2.65, 0.2, 3.2), Color("#275b7f"), true)
	_box(truck, "BedSideLeft", Vector3(-1.28, 1.55, 1.15), Vector3(0.12, 0.72, 3.2), Color("#347ca2"))
	_box(truck, "BedSideRight", Vector3(1.28, 1.55, 1.15), Vector3(0.12, 0.72, 3.2), Color("#347ca2"))
	_box(truck, "Tailgate", Vector3(0, 1.42, 2.78), Vector3(2.65, 0.72, 0.14), Color("#347ca2"))
	var stock := Marker3D.new()
	stock.name = "CargoStock"
	stock.position = Vector3(0, 1.62, 1.0)
	truck.add_child(stock)
	_label(truck, "TruckLogo", Vector3(0, 1.72, -3.12), "KIRILMAZ KARGO", Color.WHITE, 24)
	for side in [-1.0, 1.0]:
		for axle_z in [-2.0, 2.0]:
			var wheel := MeshInstance3D.new()
			wheel.name = "Wheel"
			wheel.position = Vector3(side * 1.4, 0.42, axle_z)
			wheel.rotation_degrees.z = 90
			var wheel_mesh := CylinderMesh.new()
			wheel_mesh.top_radius = 0.42
			wheel_mesh.bottom_radius = 0.42
			wheel_mesh.height = 0.28
			wheel.mesh = wheel_mesh
			wheel.material_override = _material(Color("#303941"))
			truck.add_child(wheel)
	var start_zone := Area3D.new()
	start_zone.name = "TruckStartZone"
	start_zone.collision_layer = 0
	start_zone.collision_mask = 1
	truck.add_child(start_zone)
	var zone_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(5.2, 3.2, 6.0)
	zone_shape.shape = box_shape
	start_zone.add_child(zone_shape)
	_label(self, "StartSign", Vector3(0, 4.2, 23.5), "PAKETLER BURADA!", Color("#fff1b5"), 32)

func _build_houses() -> void:
	var addresses := ["GÜNEŞ SOKAĞI 12", "GÜNEŞ SOKAĞI 28", "ÇINAR ÇIKMAZI 4"]
	for index in 3:
		var side := -1.0 if index != 1 else 1.0
		var house := Node3D.new()
		house.name = "House%d" % (index + 1)
		house.position = Vector3(side * 9.1, 0, DELIVERY_Z[index])
		add_child(house)
		_box(house, "HouseBody", Vector3(0, 1.9, 0), Vector3(4.8, 3.8, 4.6), HOUSE_COLORS[index], true)
		_box(house, "Roof", Vector3(0, 3.95, 0), Vector3(5.25, 0.35, 5.05), ROOF_COLORS[index])
		var front_x := -2.43 if side > 0.0 else 2.43
		_box(house, "Door", Vector3(front_x, 1.0, 0), Vector3(0.12, 1.75, 0.85), Color("#754b3b"))
		for window_z in [-1.35, 1.35]:
			_box(house, "Window", Vector3(front_x, 2.35, window_z), Vector3(0.12, 0.95, 1.05), Color("#b5e2ea"))
		_box(house, "WindowSill", Vector3(front_x * 1.01, 1.83, -1.35), Vector3(0.2, 0.12, 1.18), Color("#f3eee0"))
		_label(house, "Address", Vector3(0, 4.6, 0), addresses[index], Color("#fff9e7"), 22)
		var point := Area3D.new()
		point.name = "DeliveryPoint%d" % (index + 1)
		point.position = Vector3(DELIVERY_X[index] - house.position.x, 0.0, 0)
		point.collision_layer = 0
		point.collision_mask = 1
		point.set_meta("order_index", index)
		point.set_meta("address", addresses[index])
		point.add_to_group("delivery_point")
		house.add_child(point)
		var point_shape := CollisionShape3D.new()
		var sphere := SphereShape3D.new()
		sphere.radius = 2.0
		point_shape.shape = sphere
		point.add_child(point_shape)
		var marker := MeshInstance3D.new()
		marker.name = "Marker"
		marker.position.y = 0.045
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = 1.05
		cylinder.bottom_radius = 1.05
		cylinder.height = 0.06
		marker.mesh = cylinder
		marker.material_override = _material(Color("#79838b"))
		point.add_child(marker)
		var point_label := _label(point, "TargetSign", Vector3(0, 1.6, 0), "TESLIMAT %d" % (index + 1), Color("#fff2ac"), 25)
		point_label.visible = false

func _build_obstacles() -> void:
	# Ev 1 sonrasında, iki bina arasında koliyle geçilebilecek bir koridor.
	_box(self, "PassageBuildingLeft", Vector3(-5.1, 1.8, -0.2), Vector3(0.55, 3.6, 8.4), Color("#76b8c8"), true)
	_box(self, "PassageBuildingRight", Vector3(5.1, 1.8, -0.2), Vector3(0.55, 3.6, 8.4), Color("#e5a365"), true)
	_build_offset_gate("StreetGateA", 2.1, -1.15, 3.2, Color("#cf9c5b"), 4.8)
	_build_offset_gate("StreetGateB", -1.6, 1.15, 3.2, Color("#bd8752"), 4.8)
	_label(self, "StreetCourseSign", Vector3(0, 3.2, 1.6), "DAR BİNA GEÇİDİ →", Color("#fff1b5"), 22)
	var tipped_parcel := _box(self, "TippedParcel", Vector3(3.45, 0.48, -0.8), Vector3(1.25, 0.86, 1.1), Color("#bd8752"), true)
	tipped_parcel.rotation_degrees.z = 14.0
	_box(self, "PassageParcelStackSmall", Vector3(-3.65, 0.32, -3.0), Vector3(0.68, 0.62, 0.68), Color("#d6a16c"), true)

	# Kısa ve alçak köprü: kenardan inen oyuncu yakındaki zemine düşer ve rampadan tekrar çıkar.
	var bridge_up := _box(self, "BridgeRampUp", Vector3(0, 0.26, -4.7), Vector3(4.8, 0.18, 3.0), Color("#d3a76b"), true)
	bridge_up.rotation_degrees.x = 8.0
	_box(self, "NarrowBridgeDeck", Vector3(0, 0.38, -6.5), Vector3(4.8, 0.24, 3.8), Color("#bd8c50"), true)
	var bridge_down := _box(self, "BridgeRampDown", Vector3(0, 0.26, -8.3), Vector3(4.8, 0.18, 3.0), Color("#d3a76b"), true)
	bridge_down.rotation_degrees.x = -8.0
	for side in [-1.0, 1.0]:
		_box(self, "BridgeLowRail", Vector3(side * 2.32, 0.52, -6.5), Vector3(0.16, 0.48, 3.7), Color("#8a6747"), true)
	_label(self, "BridgeSign", Vector3(0, 2.8, -5.1), "DİKKAT: DAR KÖPRÜ", Color("#fff1b5"), 22)

	# Son etapta iki küçük, düşük açılı rampanın arasında kısa bir yükseltilmiş düzlük var.
	var ramp_up := _box(self, "RampUp", Vector3(0, 0.28, -19.0), Vector3(5.2, 0.18, 4.6), Color("#bd8c50"), true)
	ramp_up.rotation_degrees.x = 8.0
	_box(self, "RampCrest", Vector3(0, 0.60, -21.25), Vector3(5.2, 0.24, 1.1), Color("#d3a76b"), true)
	var ramp_down := _box(self, "RampDown", Vector3(0, 0.28, -23.5), Vector3(5.2, 0.18, 4.6), Color("#bd8c50"), true)
	ramp_down.rotation_degrees.x = -8.0
	_build_moving_barrier(Vector3(0, 0, -28.1))
	_build_offset_gate("FinalGateA", -31.3, 1.2, 3.0, Color("#e58a44"), 5.7)
	_build_offset_gate("FinalGateB", -34.4, -1.2, 3.0, Color("#d9773b"), 5.7)
	_label(self, "RampCourseSign", Vector3(0, 3.2, -27.0), "RAMPA → ZAMANLAMALI BARİYER", Color("#fff1b5"), 22)
	_label(self, "FinalCourseSign", Vector3(0, 3.1, -33.0), "SON ZİKZAK →", Color("#fff1b5"), 22)

func _build_offset_gate(node_prefix: String, z: float, opening_center: float, opening_width: float, color: Color, half_span := 7.2) -> void:
	# İki yan bariyer tek bir geniş açıklık bırakır. Açıklıklar takip eden kapıda yer değiştirir.
	var opening_left := opening_center - opening_width * 0.5
	var opening_right := opening_center + opening_width * 0.5
	var barrier_height := 1.15
	var barrier_y := barrier_height * 0.5
	var left_width := opening_left + half_span
	var right_width := half_span - opening_right
	if left_width > 0.0:
		_box(self, node_prefix + "Left", Vector3((-half_span + opening_left) * 0.5, barrier_y, z), Vector3(left_width, barrier_height, 0.48), color, true)
	if right_width > 0.0:
		_box(self, node_prefix + "Right", Vector3((opening_right + half_span) * 0.5, barrier_y, z), Vector3(right_width, barrier_height, 0.48), color, true)

func _build_cones() -> void:
	# Başlangıç konileri geniş; son bölümdekiler daha sık ama geçilebilir aralıklarla dizilir.
	var cone_positions := [
		Vector2(-2.1, 20.0), Vector2(2.0, 17.2), Vector2(-2.0, 14.4),
		Vector2(2.0, 11.6), Vector2(-2.0, 9.0),
		Vector2(-2.1, -36.8), Vector2(2.0, -38.6), Vector2(-2.0, -39.8),
	]
	for index in cone_positions.size():
		var cone_body := StaticBody3D.new()
		cone_body.name = "TrafficCone%d" % (index + 1)
		cone_body.position = Vector3(cone_positions[index].x, 0.0, cone_positions[index].y)
		cone_body.add_to_group("cargo_drop_obstacle")
		add_child(cone_body)
		var cone_mesh := MeshInstance3D.new()
		cone_mesh.name = "Visual"
		cone_mesh.position.y = 0.42
		var cone := CylinderMesh.new()
		cone.bottom_radius = 0.30
		cone.top_radius = 0.035
		cone.height = 0.84
		cone.radial_segments = 8
		cone_mesh.mesh = cone
		cone_mesh.material_override = _material(Color("#f1844d") if index % 2 == 0 else Color("#edc84f"))
		cone_body.add_child(cone_mesh)
		var shape_node := CollisionShape3D.new()
		var shape := CylinderShape3D.new()
		shape.radius = 0.30
		shape.height = 0.84
		shape_node.shape = shape
		shape_node.position.y = 0.42
		cone_body.add_child(shape_node)

func _build_trees() -> void:
	for tree_index in 9:
		var z := 19.0 - float(tree_index) * 6.6
		var near_house := false
		for delivery_z in DELIVERY_Z:
			if absf(z - delivery_z) < 3.8:
				near_house = true
				break
		if near_house:
			continue
		for side in [-1.0, 1.0]:
			var tree := Node3D.new()
			tree.name = "Tree"
			tree.position = Vector3(side * 11.2, 0, z)
			add_child(tree)
			var trunk := MeshInstance3D.new()
			trunk.position.y = 0.85
			var trunk_mesh := CylinderMesh.new()
			trunk_mesh.top_radius = 0.22
			trunk_mesh.bottom_radius = 0.3
			trunk_mesh.height = 1.7
			trunk.mesh = trunk_mesh
			trunk.material_override = _material(Color("#815738"))
			tree.add_child(trunk)
			var crown := MeshInstance3D.new()
			crown.position.y = 2.2
			var crown_mesh := SphereMesh.new()
			crown_mesh.radius = 1.0
			crown_mesh.height = 1.8
			crown.mesh = crown_mesh
			crown.material_override = _material(Color("#4f9d63") if tree_index % 2 == 0 else Color("#75ad56"))
			tree.add_child(crown)

func _build_moving_barrier(world_position: Vector3) -> void:
	var barrier := AnimatableBody3D.new()
	barrier.name = "SlowSlidingBarrier"
	barrier.position = world_position
	barrier.add_to_group("cargo_drop_obstacle")
	barrier.set_script(MOVING_BARRIER_SCRIPT)
	barrier.set("travel_distance", 1.65)
	barrier.set("move_duration", 2.8)
	add_child(barrier)
	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(7.4, 1.0, 0.42)
	visual.mesh = mesh
	visual.material_override = _material(Color("#e87e54"))
	visual.position.y = 0.75
	barrier.add_child(visual)
	var collision := CollisionShape3D.new()
	collision.name = "BarrierCollision"
	var shape := BoxShape3D.new()
	shape.size = mesh.size
	collision.shape = shape
	collision.position = visual.position
	barrier.add_child(collision)
	_label(self, "MovingBarrierWarning", Vector3(0, 2.4, -28.1), "BEKLE VE GEÇ!", Color("#fff1b5"), 20)

func _build_comedy_props() -> void:
	# Bahçe cücesi görsel dekor olarak kalır; ana geçişi kapatmaz.
	var gnome := Node3D.new()
	gnome.name = "GardenGnome"
	gnome.position = Vector3(-6.8, 0.0, 0.6)
	add_child(gnome)
	var body := MeshInstance3D.new()
	var body_mesh := SphereMesh.new()
	body_mesh.radius = 0.28
	body_mesh.height = 0.56
	body.mesh = body_mesh
	body.material_override = _material(Color("#4f9d63"))
	body.position.y = 0.32
	gnome.add_child(body)
	var hat := MeshInstance3D.new()
	var hat_mesh := CylinderMesh.new()
	hat_mesh.top_radius = 0.015
	hat_mesh.bottom_radius = 0.23
	hat_mesh.height = 0.5
	hat.mesh = hat_mesh
	hat.material_override = _material(Color("#e65f4e"))
	hat.position.y = 0.68
	gnome.add_child(hat)
	_label(self, "StartArrowSign", Vector3(3.4, 1.9, 21.0), "→ KOLİLER", Color("#fff1b5"), 22)
