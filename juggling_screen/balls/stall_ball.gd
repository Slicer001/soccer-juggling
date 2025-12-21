extends Ball
class_name StallBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_strikes = 5
	score_value = 500


func take_hit(_player: Player, _striking_force: float) -> void:
	#if remaining_strikes is even, don't teleport ball
	self.velocity = Vector2.UP * 5
	if remaining_strikes % 2 == 1:
		#teleport ball
		self.active_lane = randi_range(0, juggling_2d.lanes.size()-1)
