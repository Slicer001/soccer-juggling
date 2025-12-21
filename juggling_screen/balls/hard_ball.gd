extends Ball
class_name HardBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_strikes = 2
	score_value = 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
