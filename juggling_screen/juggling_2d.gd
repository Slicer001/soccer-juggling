extends Node2D

const BALL = preload("uid://dbg6ayu22n5tt")

var number_of_strikes := 0 : set = set_number_of_strikes
@onready var balls := [$Ball]

# Creates a new ball. 
func add_ball() -> void:
	var new_ball = BALL.instantiate()
	new_ball.position = Vector2((1920 * 0.5)*randf() + 1920*0.25, 256.0)
	self.add_child(new_ball)
	balls.append(new_ball)

func set_number_of_strikes(value: int) -> void:
	number_of_strikes = value
	if number_of_strikes % 10 == 0:
		add_ball()

func get_next_ball_right(focused_ball: Ball) -> Ball:
	var result = null
	for ball in balls:
		if ball.global_position.x > focused_ball.global_position.x:
			if result and ball.global_position.x > result.global_position.x:
				continue
			result = ball
	return result if result else focused_ball

func get_next_ball_left(focused_ball: Ball) -> Ball:
	var result = null
	for ball in balls:
		if ball.global_position.x < focused_ball.global_position.x:
			if result and ball.global_position.x < result.global_position.x:
				continue
			result = ball
	return result if result else focused_ball
