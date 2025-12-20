extends Node2D
class_name Ball

const GRAVITY := Vector2(0, 9.8)
const WARNING_THRESHOLD := 5

@onready var area_2d: Area2D = $Area2D
@onready var outline: Sprite2D = $Outline
@onready var warning: Node2D = $Warning

var remaining_strikes = 100

var moving := true
var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var juggling_screen = self.get_parent().get_parent()
	if moving:
		#calculate velocity
		velocity += GRAVITY * delta * juggling_screen.physics_speed
		#move down by that amount
		self.position += velocity * juggling_screen.physics_speed
	#if falling quickly, show warning
	if velocity.y > WARNING_THRESHOLD:
		warning.show()
	else:
		warning.hide()


func strike(striking_force: float) -> void:
	remaining_strikes -= 1
	#how many times left to hit the ball before it is done
	if remaining_strikes > 0:
		moving = true
		self.velocity = Vector2((randf()-0.5) * 2.0, striking_force * -1)
	if remaining_strikes <= 0:
		#if on the left side of the screen, kick off to the left
		if self.position.x < 1920 * 0.5:
			self.velocity = Vector2(striking_force * -1, striking_force * -1)
		else:
			self.velocity = Vector2(striking_force, striking_force * -1)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Ground":
		self.velocity *= -0.5
		if self.velocity.length() <= 1.0:
			self.velocity = Vector2.ZERO
			self.moving = false
