extends Node2D
class_name Player

@onready var area_2d: Area2D = $Area2D

#strike related stuff
@onready var strike_qte: Node2D = $StrikeQTE
@onready var strike_bar: Sprite2D = $StrikeQTE/StrikeBar
@onready var strike_marker: Sprite2D = $StrikeQTE/StrikeMarker
@onready var strike_hint: Sprite2D = $StrikeHint


const STRIKE_TIME := 1.0
const STRIKE_BAR_SIZE := 29
const INVINCIBILITY_TIME := 1.0

var focused_ball: Ball = null : set = set_focused_ball
var striking_tween: Tween = null
var striking := false
var power := 1

var invincible := false : set = set_invincible
var invincible_timer := 0.0
var low_alpha := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#snap to ball if focused
	if focused_ball:
		self.global_position.x = focused_ball.global_position.x
	#blink if invincible
	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0.0:
			low_alpha = not low_alpha
			self.modulate = Color(1, 1, 1, 0.25) if low_alpha else Color(1, 1, 1, 0.75)
			invincible_timer = 0.1

func _input(event: InputEvent) -> void:
	var juggling_2d = self.get_parent()
	#switching focused balls
	if event.is_action_pressed("ui_left") and not striking:
		var next_ball = juggling_2d.get_next_ball_left(self.global_position)
		focused_ball = next_ball if next_ball else focused_ball
	if event.is_action_pressed("ui_right") and not striking:
		var next_ball = juggling_2d.get_next_ball_right(self.global_position)
		focused_ball = next_ball if next_ball else focused_ball
	#begin striking ball
	if focused_ball and event.is_action_pressed("ui_up"):
		if area_2d.overlaps_area(focused_ball.area_2d):
			#self.begin_strike()
			self.auto_strike()
	#activate strike
	if event.is_action_released("ui_up"):
		if focused_ball and striking:
			self.activate_strike()

func begin_strike() -> void:
	#slow down time
	var juggling_2d = self.get_parent()
	juggling_2d.set_physics_speed(0.01)
	#start striking
	striking = true
	strike_hint.hide()
	#show popup
	strike_marker.position = Vector2(0, STRIKE_BAR_SIZE * 0.5)
	strike_qte.show()
	#set kicking to true
	striking_tween = get_tree().create_tween()
	striking_tween.tween_property(strike_marker, "position", Vector2(0, STRIKE_BAR_SIZE * -0.5), STRIKE_TIME)
	#start moving bar up the popup
	pass

func activate_strike() -> void:
	#first, stop tween
	if striking_tween:
		striking_tween.kill()
		striking_tween = null
	#resume speed
	var juggling_2d = self.get_parent()
	juggling_2d.set_physics_speed(1.0)
	#hide strike
	strike_qte.hide()
	#see how good the strike was
	var striking_force = (STRIKE_BAR_SIZE * 0.5 - strike_marker.position.y) * power
	#use strike to determing force
	focused_ball.strike(self, striking_force)
	#no longer striking
	striking = false
	#increase strike count
	juggling_2d.number_of_strikes += 1

func auto_strike() -> void:
	#first, stop tween
	if striking_tween:
		striking_tween.kill()
		striking_tween = null
	#resume speed
	var juggling_2d = self.get_parent()
	juggling_2d.set_physics_speed(1.0)
	#hide strike
	strike_hint.hide()
	strike_qte.hide()
	#see how good the strike was
	var striking_force = 14.5
	#use strike to determing force
	focused_ball.strike(self, striking_force)
	#no longer striking
	striking = false
	#increase strike count
	juggling_2d.number_of_strikes += 1



func set_focused_ball(value: Ball) -> void:
	if focused_ball:
		focused_ball.outline.hide()
	focused_ball = value
	if focused_ball:
		focused_ball.outline.show()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() == focused_ball:
		strike_hint.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() == focused_ball:
		strike_hint.hide()

func set_invincible(value: bool) -> void:
	invincible = value
	#reset invincibility in one seconds
	if invincible:
		var invincible_tween = get_tree().create_tween()
		invincible_tween.tween_callback(self.set_invincible.bind(false)).set_delay(INVINCIBILITY_TIME)
	else:
		self.modulate = Color(1, 1, 1, 1)
