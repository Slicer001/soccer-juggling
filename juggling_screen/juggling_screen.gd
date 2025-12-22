extends Node
class_name JugglingScreen

@onready var transition_player: AnimationPlayer = $TransitionPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var juggling_2d: Juggling2D = $Juggling2D
@onready var select_menu: AudioStreamPlayer = $SelectMenu

func play_defeated_animation() -> void:
	juggling_2d.physics_speed = 0
	animation_player.play("defeated")

func _on_retry_button_pressed() -> void:
	select_menu.play()
	transition_player.play("trans_out_retry")

func retry() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	select_menu.play()
	transition_player.play("trans_out_quit")

func quit() -> void:
	select_menu.play()
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
