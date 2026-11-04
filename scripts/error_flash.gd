
extends ColorRect

var flash_tween: Tween

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

	color = Color(1, 0, 0, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 100
	show_behind_parent = false

	print("ErrorFlash size: ", size)


func flash_red() -> void:
	print("RED FLASH TRIGGERED")

	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	color = Color(1, 0, 0, 0.0)
	visible = true

	flash_tween = create_tween()
	flash_tween.tween_property(self, "color:a", 0.8, 0.15)
	flash_tween.tween_interval(0.1)
	flash_tween.tween_property(self, "color:a", 0.0, 0.5)
