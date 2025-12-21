extends Node2D
class_name Ball

const GRAVITY := Vector2(0, 9.8)
const WARNING_THRESHOLD := 5

@onready var area_2d: Area2D = $Area2D
@onready var outline: Sprite2D = $Outline
@onready var warning: Node2D = $Warning

var remaining_strikes := 1
var score_value := 100

var moving := true
var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var juggling_2d = self.get_parent()
	if moving:
		#calculate velocity
		velocity += GRAVITY * delta * juggling_2d.physics_speed
		#move down by that amount
		self.position += velocity * juggling_2d.physics_speed
	#if falling quickly, show warning
	if velocity.y > WARNING_THRESHOLD:
		warning.show()
	else:
		warning.hide()


func strike(player: Player, striking_force: float) -> void:
	remaining_strikes -= 1
	#how many times left to hit the ball before it is done
	if remaining_strikes > 0:
		moving = true
		take_hit(player, striking_force)
	if remaining_strikes <= 0:
		#remove self from list
		var juggling_2d = self.get_parent()
		juggling_2d.balls.erase(self)
		#remove ball from player
		juggling_2d.player.focused_ball = null
		#if on the left side of the screen, kick off to the left
		if self.position.x < 1920 * 0.5:
			self.velocity = Vector2(striking_force * -1, striking_force * -1)
		else:
			self.velocity = Vector2(striking_force, striking_force * -1)
		#delete ball after 2 seconds (once it goes off screen)
		var queue_free_tween = self.get_tree().create_tween()
		queue_free_tween.tween_callback(self.queue_free).set_delay(2.0)
		#update streak
		juggling_2d.number_of_strikes += 1
		juggling_2d.streak += 1
		#update current score
		var points = self.get_points(striking_force)
		juggling_2d.increase_score(points)

func take_hit(_player: Player, striking_force: float) -> void:
	self.velocity = Vector2(0, striking_force * -1)

func get_points(striking_force: float) -> int:
	var accuracy = 1.0 - (abs(striking_force - 14.5) / 14.5)
	#if close enough, give full score
	if abs(accuracy - 1.0) < 0.05:
		accuracy = 1.0
	print(accuracy)
	return int(accuracy * score_value)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Ground":
		#set current streak to 0
		var juggling_2d = self.get_parent()
		juggling_2d.damage_player()
		#remove this ball from the equation
		juggling_2d.balls.erase(self)
		juggling_2d.player.focused_ball = null
		var queue_free_tween = self.get_tree().create_tween()
		queue_free_tween.tween_callback(self.queue_free).set_delay(2.0)
		#bounce the ball
		self.velocity *= -0.5
		if self.velocity.length() <= 1.0:
			self.velocity = Vector2.ZERO
			self.moving = false
