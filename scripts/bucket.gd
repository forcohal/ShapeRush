
extends Area2D

@onready var circle = $BucketCircle
@onready var square = $BucketSquare
@onready var triangle = $BucketTriangle
@onready var star = $BucketStar

var current_shape = 0
var shapes = []
var is_changing = false


func _ready() -> void:
	shapes = [square, circle, triangle, star]
	update_shape()


func get_current_shape() -> String:
	return ["square", "circle", "triangle", "star"][current_shape]


func update_shape() -> void:
	for shape in shapes:
		shape.visible = false
		shape.modulate.a = 1.0

	shapes[current_shape].visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		change_shape()

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			change_shape()


func change_shape() -> void:
	if is_changing:
		return

	is_changing = true

	var old_shape = shapes[current_shape]

	# Fade out the current shape.
	var tween = create_tween()
	tween.tween_property(old_shape, "modulate:a", 0.0, 0.2)

	# Switch shapes after the fade-out.
	tween.tween_callback(func():
		old_shape.visible = false
		old_shape.modulate.a = 1.0

		current_shape = (current_shape + 1) % shapes.size()

		# Play the shape-changing sound.
		$ChangeSound.play()

		var new_shape = shapes[current_shape]
		new_shape.modulate.a = 0.0
		new_shape.visible = true

		# Fade in the new shape.
		var fade_in = create_tween()
		fade_in.tween_property(new_shape, "modulate:a", 1.0, 0.2)

		fade_in.tween_callback(func():
			is_changing = false
		)
	)
