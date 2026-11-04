
extends Control

var game_started: bool = false


func _input(event: InputEvent) -> void:
	if game_started:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_game()

	elif event is InputEventScreenTouch and event.pressed:
		start_game()


func start_game() -> void:
	game_started = true
	get_tree().change_scene_to_file("res://scenes/game.tscn")
