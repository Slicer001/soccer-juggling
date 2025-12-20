extends Node
class_name JugglingScreen

var physics_speed = 1.0

func set_physics_speed(value: float) -> void:
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "physics_speed", value, 0.25)
