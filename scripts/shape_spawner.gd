
extends Node2D

# Smallest gaps (in pixels) the game will ever shrink to.
const MIN_DISTANCE_LIMIT: float = 140.0
const MAX_DISTANCE_LIMIT: float = 200.0

const START_MIN_DISTANCE: float = 400.0
const START_MAX_DISTANCE: float = 600.0
const SCORE_STEP: int = 5
const DISTANCE_DECREASE: float = 8.0

var shape_scenes = [
	preload("res://scenes/circle_falling.tscn"),
	preload("res://scenes/square_falling.tscn"),
	preload("res://scenes/triangle_falling.tscn"),
	preload("res://scenes/star_falling.tscn")
]

var current_score: int = 0
var min_spawn_distance: float = START_MIN_DISTANCE
var max_spawn_distance: float = START_MAX_DISTANCE

var spawn_y: float = -100.0
var next_spawn_y: float = 0.0
var last_spawned_shape: Node2D
var waiting_for_distance: bool = false

# Track consecutive shapes.
var last_shape_index: int = -1
var consecutive_count: int = 0


func _ready() -> void:
	randomize()
	spawn_shape()


func _process(_delta: float) -> void:
	if not waiting_for_distance:
		return

	# Spawn immediately if the previous shape has been removed.
	if not is_instance_valid(last_spawned_shape):
		spawn_shape()
		return

	# Spawn when the previous shape reaches the target position.
	if last_spawned_shape.position.y >= next_spawn_y:
		spawn_shape()


func spawn_shape() -> void:
	var random_index: int = randi_range(0, shape_scenes.size() - 1)

	# Prevent the same shape from appearing more than twice consecutively.
	while random_index == last_shape_index and consecutive_count >= 2:
		random_index = randi_range(0, shape_scenes.size() - 1)

	# Update the consecutive-shape counter.
	if random_index == last_shape_index:
		consecutive_count += 1
	else:
		last_shape_index = random_index
		consecutive_count = 1

	# Create and position the shape.
	var shape: Node2D = shape_scenes[random_index].instantiate()
	shape.position = Vector2(240, spawn_y)
	add_child(shape)

	last_spawned_shape = shape

	# Choose a random distance for the next spawn.
	var distance: float = randf_range(min_spawn_distance, max_spawn_distance)
	next_spawn_y = spawn_y + distance

	waiting_for_distance = true


func update_difficulty(score: int) -> void:
	current_score = score
	var difficulty_level: int = int(current_score / SCORE_STEP)

	min_spawn_distance = max(
		MIN_DISTANCE_LIMIT,
		START_MIN_DISTANCE - difficulty_level * DISTANCE_DECREASE
	)

	max_spawn_distance = max(
		MAX_DISTANCE_LIMIT,
		START_MAX_DISTANCE - difficulty_level * DISTANCE_DECREASE
	)
