extends TextureButton

onready var normal_pos : Vector2 = rect_position
export var hover_pos : Vector2

onready var normal_size : Vector2 = rect_size
export var pressed_size : Vector2

export(Array, String, MULTILINE) var inspect_dialog
# By default it'll be true since this is only useful for a couple scenarios

func _on_Button_pressed():
	if range(inspect_dialog.size()).has(0):
		if !Global.sequence_active:
			Global.dialogue.trigger_dialogue(inspect_dialog)

func _on_Button_mouse_entered():
	rect_position = normal_pos + hover_pos

func _on_Button_mouse_exited():
	rect_position = normal_pos

func _on_Button_down():
	rect_size = normal_size + pressed_size

func _on_Button_up():
	rect_size = normal_size
