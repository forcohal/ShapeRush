
extends Area2D

@onready var circle = $BucketCircle
@onready var square = $BucketSquare
@onready var triangle = $BucketTriangle
@onready var star = $BucketStar

var shapes: Array = []
var current_shape: int = 0

const SHAPE_CHANGE_INTERVAL: float = 1.0


func _ready() -> void:
	shapes = [square, circle, triangle, star]

	update_shape()

	while true:
		await get_tree().create_timer(SHAPE_CHANGE_INTERVAL).timeout
		change_shape()


func update_shape() -> void:
	for shape in shapes:
		shape.visible = false
		shape.modulate.a = 1.0

	shapes[current_shape].visible = true


func change_shape() -> void:
	var old_shape = shapes[current_shape]

	var tween = create_tween()
	tween.tween_property(old_shape, "modulate:a", 0.0, 0.2)

	await tween.finished

	old_shape.visible = false
	old_shape.modulate.a = 1.0

	current_shape = (current_shape + 1) % shapes.size()

	var new_shape = shapes[current_shape]
	new_shape.modulate.a = 0.0
	new_shape.visible = true

	var fade_in = create_tween()
	fade_in.tween_property(new_shape, "modulate:a", 1.0, 0.2)

	await fade_in.finished
