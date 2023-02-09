class_name player_interface
extends CanvasLayer

# Probably dumb to put all this in the interface.
# Too bad!

var active_dialogue = []
var dialogue_index : int = -1
var dialogue_active : bool = false
var can_continue : bool = true

onready var animator = $InterfaceAnimator

onready var sylladex = Global.sylladex
var sylladex_open : bool = false

onready var inspect_button = $InspectableButton
onready var captcha_button = $CaptchableButton
onready var sylladex_button = $SylladexButton

onready var dialogue_box = $DialogueBox
onready var dialogue_text = $DialogueBox/InnerPanel/DialogueText
onready var help_button = $HelpButton

func _input(event):
	if event.is_action_released("toggle_inspector"):
		toggle_inspector()
	
	if event.is_action_released("toggle_sylladex"):
		toggle_sylladex()

# Had to separate this function into two more additional methods
# because I want to manually toggle the sylladex's active state in other ways than just
# the button in the topleft corner
func toggle_sylladex():
	if !Global.sequence_active:
		sylladex_open = !sylladex_open
		
		if sylladex_open:
			open_sylladex()
		else:
			close_sylladex()

func open_sylladex():
	sylladex.visible = true
	animator.play("SylladexOpen")

func close_sylladex():
	animator.play("SylladexClose")
	yield(get_tree().create_timer(0.15), "timeout")
	sylladex.visible = false

# Used by the two inspector buttons in the interface to swap between both inspector types
func toggle_inspector():
	if Global.sequence_active:
		return
	
	if Global.inspect_mode == Global.InspectorMode.INSPECTABLE:
		Global.inspect_mode = Global.InspectorMode.CAPTCHABLE
		inspect_button.visible = false
		captcha_button.visible = true
	else:
		Global.inspect_mode = Global.InspectorMode.INSPECTABLE
		captcha_button.visible = false
		inspect_button.visible = true
	
	print (Global.inspect_mode)

# This one should be called by interactables like popups that need to temporarily disable the inspector.
# because the icons for each will be visible through slightly transparent popups if the inspector isnt "off"
# also just a good thing in general in case of something like a camera cutscene or whatever
# maybe todo: have a way of remembering
func force_inspector(new_mode : String):
	var target_mode = new_mode.to_upper()
	
	if target_mode != "OFF":
		Global.inspect_mode = Global.InspectorMode.get(target_mode)
	
	match target_mode:
		"INSPECTABLE":
			inspect_button.visible = true
			captcha_button.visible = false
		"CAPTCHABLE":
			inspect_button.visible = false
			captcha_button.visible = true
		"OFF":
			inspect_button.visible = false
			captcha_button.visible = false
		_:
			# Just default to inspectable after fuck it why not
			inspect_button.visible = true
			captcha_button.visible = false
	
	print(Global.inspect_mode)

func set_interface(status : bool):
	inspect_button.visible = status
	captcha_button.visible = status
	help_button.visible = status
	sylladex_button.visible = status
