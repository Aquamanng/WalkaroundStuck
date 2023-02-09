class_name Interactable
extends Area2D

# Interactables are fun because they're pretty damn flexible.
# Just derive from this base class and make sure you have a do_interaction function in the script,
# and you can do just about anything you want.
# I've already included a bunch of stuff for a more broad scope of Walkaround-esque features,
# like small popup screens, activating/deactivating objects, dialogue, captchables, and the like.
# // TODO: Add animation triggering and camera cinematic positioning sequence bullshit \\

export var inspect_title : String
onready var inspect_text = $OuterMargins/InnerMargins/HBoxContainer/Text
onready var inspect_box = $OuterMargins
export var box_offset = Vector2(30, 0)

onready var hint_sprite = $HintSprite

var enable_interact = false
var can_use = false

func _ready():
	inspect_text.text = inspect_title
	set_process(false)
	hint_sprite.visible = false

func _process(_delta):
	interact_hover()
	
	if Global.inspector_active:
		if is_in_group("Inspectables") and Global.inspect_mode == Global.InspectorMode.INSPECTABLE:
			hint_sprite.visible = true
			inspect_box.visible = true
			can_use = true
		elif is_in_group("Captchables") and Global.inspect_mode == Global.InspectorMode.CAPTCHABLE:
			hint_sprite.visible = true
			inspect_box.visible = true
			can_use = true
		else:
			hint_sprite.visible = false
			inspect_box.visible = false
			can_use = false
	else:
		hint_sprite.visible = false

func interact_hover():
	inspect_box.rect_global_position = get_global_mouse_position() + box_offset

func _input(event):
	if event.is_action_released("submit") and enable_interact and can_use:
		do_interaction()

func do_interaction():
	print("Interaction triggered @" + name)

func _on_Interactable_mouse_entered():
	set_process(true)
	enable_interact = true

func _on_Interactable_mouse_exited():
	set_process(false)
	enable_interact = false
	hint_sprite.visible = false
	inspect_box.visible = false
