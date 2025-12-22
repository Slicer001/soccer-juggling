extends Node
class_name JugglingScreen

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var juggling_2d: Juggling2D = $Juggling2D

func play_defeated_animation() -> void:
	juggling_2d.physics_speed = 0
	animation_player.play("defeated")

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
