extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_play_pressed() -> void:
	# Changes the scene to main.tscm
	# TODO: Load Test Level
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_exit_pressed() -> void:
	# Exits the game
	get_tree().quit()

func _on_options_pressed() -> void:
	pass
