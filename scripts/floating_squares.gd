
extends Node2D

var squares: Array[Dictionary] = []
var screen_size: Vector2

func _ready() -> void:
	randomize()
	screen_size = get_viewport_rect().size

	for i in range(20):
		squares.append({
			"position": Vector2(
				randf_range(0, screen_size.x),
				randf_range(0, screen_size.y)
			),
			"size": randf_range(3, 7),
			"speed": randf_range(15, 40),
			"alpha": randf_range(0.2, 0.7),
			"phase": randf_range(0, 6.28)
		})


func _process(delta: float) -> void:
	for square in squares:
		var pos: Vector2 = square["position"]

		pos.y -= square["speed"] * delta
		pos.x += sin(
			Time.get_ticks_msec() * 0.001 + square["phase"]
		) * 8.0 * delta

		if pos.y < -10:
			pos.y = screen_size.y + 10
			pos.x = randf_range(0, screen_size.x)

		square["position"] = pos

	queue_redraw()


func _draw() -> void:
	for square in squares:
		var pos: Vector2 = square["position"]
		var size: float = square["size"]
		var alpha: float = square["alpha"]

		draw_rect(
			Rect2(pos, Vector2(size, size)),
			Color(1, 1, 1, alpha)
		)
