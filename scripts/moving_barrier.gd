extends AnimatableBody3D

@export_range(0.2, 4.0, 0.1) var travel_distance: float = 1.65
@export_range(1.0, 8.0, 0.1) var move_duration: float = 2.8

func _ready() -> void:
	var start_x := position.x
	var motion := create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	motion.tween_property(self, "position:x", start_x + travel_distance, move_duration)
	motion.tween_property(self, "position:x", start_x - travel_distance, move_duration)
	motion.tween_property(self, "position:x", start_x, move_duration)
