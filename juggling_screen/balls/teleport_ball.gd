extends Ball
class_name TeleportBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_strikes = 3
	score_value = 300


func take_hit(player: Player, _striking_force: float) -> void:
	#disconnect player
	player.focused_ball = null
	#teleport ball
	self.velocity = Vector2.UP * 5
	self.position = Vector2((1920 * 0.5)*randf() + 1920*0.25, 256.0)
