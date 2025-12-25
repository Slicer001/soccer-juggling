extends CenterContainer
class_name Dad

var normal = preload("uid://dwngjqmmlawxn")
var blink = preload("uid://cxn15i1tk1ajr")
var mouth_open = preload("uid://c2ols2nvslbhb")

@onready var face_texture: TextureRect = $FaceTexture
@onready var frame_texture: TextureRect = $FrameTexture

var talking = false : set = set_talking
var blinking = false : set = set_blinking
var blink_timer = randf() * 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	blink_timer -= delta
	if blink_timer <= 0.0:
		blinking = not blinking
		if blinking:
			blink_timer = 0.25
		else:
			blink_timer = randf() * 10

func set_blinking(value: bool) -> void:
	if talking:
		return
	blinking = value
	if blinking:
		face_texture.texture = blink
	else:
		face_texture.texture = normal

func set_talking(value: bool) -> void:
	talking = value
	if talking:
		face_texture.texture = mouth_open
	else:
		face_texture.texture = normal
