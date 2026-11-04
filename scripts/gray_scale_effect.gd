
extends ColorRect
@onready var end_sound = get_tree().current_scene.get_node("EndSound")
var is_game_over = false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 100
	process_mode = Node.PROCESS_MODE_ALWAYS

	color = Color.WHITE
	material.set_shader_parameter("grayscale_amount", 0.0)


func flash_grayscale() -> void:
	if is_game_over:
		return

	is_game_over = true
	end_sound.play()
	var game_music = get_tree().current_scene.get_node("GameMusic")
	game_music.stream_paused = true
	var tween = create_tween()
	tween.tween_method(set_grayscale, 0.0, 1.0, 1.0)
	tween.tween_callback(pause_game)


func set_grayscale(value: float) -> void:
	material.set_shader_parameter("grayscale_amount", value)


func pause_game() -> void:
	get_tree().paused = true
func _input(event: InputEvent) -> void:
	if not is_game_over:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			restart_game()

	elif event is InputEventScreenTouch and event.pressed:
		restart_game()


func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
