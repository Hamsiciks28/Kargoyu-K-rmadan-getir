extends RigidBody3D

enum CargoType { LIGHT, NORMAL, HEAVY }

@export_group("Koli türü")
@export_enum("Hafif", "Normal", "Ağır") var koli_turu: int = CargoType.NORMAL

@export_group("Kütle")
@export_range(0.5, 4.0, 0.1) var hafif_koli_kutlesi: float = 0.75
@export_range(0.5, 4.0, 0.1) var normal_koli_kutlesi: float = 1.5
@export_range(0.5, 6.0, 0.1) var agir_koli_kutlesi: float = 3.0

@export_group("Görünüm")
@export var hafif_koli_rengi := Color(0.83, 0.68, 0.32, 1.0)
@export var normal_koli_rengi := Color(0.68, 0.39, 0.17, 1.0)
@export var agir_koli_rengi := Color(0.43, 0.30, 0.25, 1.0)

@onready var box_visual: MeshInstance3D = $Box

func _ready() -> void:
	_apply_cargo_type()

func _apply_cargo_type() -> void:
	var selected_mass: float
	var selected_color: Color
	match koli_turu:
		CargoType.LIGHT:
			selected_mass = hafif_koli_kutlesi
			selected_color = hafif_koli_rengi
		CargoType.HEAVY:
			selected_mass = agir_koli_kutlesi
			selected_color = agir_koli_rengi
		_:
			selected_mass = normal_koli_kutlesi
			selected_color = normal_koli_rengi

	mass = selected_mass
	var material := box_visual.material_override as StandardMaterial3D
	if material != null:
		var unique_material := material.duplicate() as StandardMaterial3D
		unique_material.albedo_color = selected_color
		box_visual.material_override = unique_material
