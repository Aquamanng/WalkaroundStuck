class_name DialogueBox
extends Panel

onready var text = $InnerPanel/DialogueText
onready var timer = $DelayTimer

var active_dialogue = []
var dialogue_index : int = -1

func _input(event):
	if event.is_action_released("submit") and Global.continue_dialog and Global.dialog_active:
		progress_dialogue()

func trigger_dialogue(dialogue_array):
	if Global.dialog_active or !Global.continue_dialog:
		return
	
	active_dialogue = dialogue_array
	dialogue_index = -1
	progress_dialogue()
	
	visible = true
	Global.dialog_active = true

func progress_dialogue():
	dialogue_index += 1
	
	if dialogue_index >= len(active_dialogue):
		dialogue_index = -1
		Global.dialog_active = false
		visible = false
		return
	
	text.text = active_dialogue[dialogue_index]
	
	Global.continue_dialog = false
	timer.start()

# Note to self: maybe make the timer a part of global for global sequence stuff
# we'll see later on
func _on_Timer_timeout():
	Global.continue_dialog = true
