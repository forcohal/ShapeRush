extends Area2D

var fall_speed: float = 250.0

func _ready() -> void:
	fall_speed = get_tree().current_scene.fall_speed
	
func _process(delta: float) -> void:
	position.y += fall_speed * delta

func _on_area_entered(area: Area2D) -> void:
	print(area.get_current_shape())
	if area.is_in_group("buckets"):
		if area.get_current_shape() == "triangle":
			get_tree().current_scene.increase_score()
			print("Correct!")
		else:
			print("Incorrect!")
			get_tree().current_scene.get_node("CanvasLayer/GrayscaleEffect").flash_grayscale()

		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.tween_callback(queue_free)
