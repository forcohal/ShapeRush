
extends Node2D

var score: int = 0
var coins: int = 0
var fall_speed: float = 130.0

const SAVE_PATH: String = "user://player_data.cfg"

@onready var game_music = $GameMusic
@onready var background: ColorRect = $Background
@onready var shape_spawner = $ShapeSpawner
@onready var coin_label: Label = $GameUI/CoinDisplay/Coins

@onready var score_sounds = [
	$ScoreSound1,
	$ScoreSound2,
	$ScoreSound3
]

@onready var score_music = $ScoreMusic

var sound_index: int = 0

const COLOR_STEP: int = 1
const STEP_INTERVAL: float = 0.02

var background_colors: Array[Color] = [
	Color("#FEEAC7"),
	Color("#CAF0F8"),
	Color("#E2D9F3"),
	Color("#4A2468"),
	Color("#2B1B4D"),
	Color("#FFD6E0"),
	Color("#E9EDC9"),
	Color("#3C1F5E"),
	Color("#1F1535"),
	Color("#D8F3DC"),
	Color("#FAEDCD"),
	Color("#351B4A")
]

var current_rgb: Vector3i
var target_rgb: Vector3i
var step_timer: float = 0.0


func _ready() -> void:
	load_player_data()
	update_coin_display()

	game_music.play()

	var start: Color = background_colors[0]
	current_rgb = _to_rgb(start)
	target_rgb = current_rgb
	background.color = start


func _process(delta: float) -> void:
	if current_rgb == target_rgb:
		return

	step_timer += delta

	while step_timer >= STEP_INTERVAL and current_rgb != target_rgb:
		step_timer -= STEP_INTERVAL
		current_rgb.x = _step_toward(current_rgb.x, target_rgb.x)
		current_rgb.y = _step_toward(current_rgb.y, target_rgb.y)
		current_rgb.z = _step_toward(current_rgb.z, target_rgb.z)

	if current_rgb == target_rgb:
		step_timer = 0.0

	background.color = Color8(
		current_rgb.x,
		current_rgb.y,
		current_rgb.z
	)


func increase_score() -> void:
	score += 1

	if score % 5:
		score_music.play()

	fall_speed = min(fall_speed + 4.0, 280.0)
	shape_spawner.update_difficulty(score)

	# Reward: 1 coin for every correct match.
	coins += 1

	# Bonus: 5 additional coins every 10 scores.
	if score % 10 == 0:
		coins += 5
		print("Bonus! +5 coins")

	# Update the coin counter and save progress.
	update_coin_display()
	save_player_data()

	# Change background colour every 5 scores.
	if score % 5 == 0:
		score_sounds[sound_index].play()
		sound_index = (sound_index + 1) % score_sounds.size()

		var color_index: int = score % background_colors.size()
		target_rgb = _to_rgb(background_colors[color_index])

	print("Score: ", score)
	print("Coins: ", coins)
	print("Fall speed: ", fall_speed)


func update_coin_display() -> void:
	coin_label.text = str(coins)


func save_player_data() -> void:
	var config := ConfigFile.new()

	config.set_value("player", "coins", coins)

	var error := config.save(SAVE_PATH)

	if error != OK:
		print("Error saving coins: ", error)
	else:
		print("Coins saved successfully!")


func load_player_data() -> void:
	var config := ConfigFile.new()

	var error := config.load(SAVE_PATH)

	if error == OK:
		coins = int(config.get_value("player", "coins", 0))
	else:
		coins = 0

	print("Loaded coins: ", coins)


func _step_toward(current: int, target: int) -> int:
	if current < target:
		return mini(current + COLOR_STEP, target)
	elif current > target:
		return maxi(current - COLOR_STEP, target)

	return current


func _to_rgb(c: Color) -> Vector3i:
	return Vector3i(c.r8, c.g8, c.b8)
