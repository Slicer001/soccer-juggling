extends Control

const JUGGLING_SCREEN = preload("uid://bm80fte4ltpp7")

@onready var select_sfx: AudioStreamPlayer = $SelectSFX
@onready var tutorial_button: Button = $VBoxContainer/TutorialButton
@onready var transition: ColorRect = $Transition
@onready var free_play_button: Button = $VBoxContainer/FreePlayButton

var transition_tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	free_play_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_free_play_button_pressed() -> void:
	if transition_tween:
		return
	select_sfx.play()
	transition_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	transition_tween.tween_property(transition, "color", Color(0, 0, 0, 1), 1.0)
	transition_tween.tween_callback(get_tree().change_scene_to_packed.bind(JUGGLING_SCREEN))
	#get_tree().change_scene_to_packed(JUGGLING_SCREEN)

func _on_quit_button_pressed() -> void:
	if transition_tween:
		return
	select_sfx.play()
	transition_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	transition_tween.tween_callback(get_tree().quit).set_delay(0.5)
