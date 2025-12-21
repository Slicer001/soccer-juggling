extends Node2D
class_name Juggling2D

const BALL = preload("uid://dbg6ayu22n5tt")
const HARD_BALL = preload("uid://dyu8opqkhoqx0")
const TELEPORT_BALL = preload("uid://bqqs4077a8wyd")
const STRONG_BALL = preload("uid://dh4c1qk7o53tg")
const STALL_BALL = preload("uid://crpcvvsw1iyfs")

@onready var hud: HUD = $"../HUD"
@onready var player: Player = $Player
@onready var lanes := [$Lanes/Lane1, $Lanes/Lane2, $Lanes/Lane3, $Lanes/Lane4]

var score := 0 : set = set_score

var physics_speed := 1.0

var number_of_strikes := 0 : set = set_number_of_strikes
var streak := 0
var balls := []

var ball_timer_length := 2.5 #seconds between ball spawns
var ball_timer: float = ball_timer_length

func _ready() -> void:
	start_game()

func _physics_process(delta: float) -> void:
	ball_timer -= delta * physics_speed
	if ball_timer <= 0:
		add_ball()
		ball_timer = ball_timer_length * pow(0.99, streak)
		print(ball_timer)

# Starts a game.
func start_game() -> void:
	ball_timer = ball_timer_length

# Creates a new ball. 
func add_ball() -> void:
	#choose ball type
	var ball_type = BALL
	if randf() < 0.01 * number_of_strikes and number_of_strikes >= 10:
		ball_type = HARD_BALL
	if randf() < 0.005 * number_of_strikes and number_of_strikes >= 20:
		ball_type = TELEPORT_BALL
	if randf() < 0.003 * number_of_strikes and number_of_strikes >= 30:
		ball_type = STRONG_BALL
	if randf() < 0.0025 * number_of_strikes and number_of_strikes >= 40:
		ball_type = STALL_BALL
	#create ball with random lane
	var lane = randi_range(0, lanes.size()-1)
	var new_ball = ball_type.instantiate()
	new_ball.setup(self, lane)
	self.add_child(new_ball)
	balls.append(new_ball)

# Updates the score.
func increase_score(points) -> void:
	points *= streak #increase for current streak
	points *= (3.0 / ball_timer_length) #increase for ball speed
	#increase for player kick speed
	score += int(points)

# Gets called when a ball hits the ground.
func damage_player() -> void:
	#skip if invincible
	if player.invincible:
		return
	#reset streak
	streak = 0
	#take damage
	hud.health -= 1
	#set invincible
	player.invincible = true
	#reset all ball drop speeds
	for ball: Ball in balls:
		ball.velocity = Vector2.UP * 5
	#if health below zero, die
	if hud.health <= 0:
		#run death screen
		pass

func set_number_of_strikes(value: int) -> void:
	number_of_strikes = value
	if number_of_strikes % 10 == 0:
		add_ball()

func get_next_ball_right(current_position: Vector2) -> Ball:
	var result = null
	for ball in balls:
		if ball.global_position.x > current_position.x:
			if result and ball.global_position.x > result.global_position.x:
				continue
			result = ball
	return result if result else null

func get_next_ball_left(current_position: Vector2) -> Ball:
	var result = null
	for ball in balls:
		if ball.global_position.x < current_position.x:
			if result and ball.global_position.x < result.global_position.x:
				continue
			result = ball
	return result if result else null

func set_physics_speed(value: float) -> void:
	var tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "physics_speed", value, 0.25)

func set_score(value: int) -> void:
	score = value
	hud.update_score(score)

func get_lane_global_position(lane: int) -> Vector2:
	return lanes[lane].global_position

func get_next_lane(current_lane: int, direction: int) -> int:
	return (current_lane + lanes.size() + direction) % lanes.size()

func get_next_ball(lane: int) -> Ball:
	var result = null
	for ball: Ball in balls:
		if ball.active_lane == lane:
			if result:
				if ball.position.y > result.position.y:
					result = ball
			else:
				result = ball
	return result
