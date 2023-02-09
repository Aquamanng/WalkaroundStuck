class_name Transitionable
extends Interactable

# Will look in res://Scenes/Rooms/ + target_folder + room_name
export var target_folder : String
export var room_name : String
# Look for name of warp node in root of new room scene
# then set player pos to it
# its that shrimple
export var warp_to : String

# If blank no key required
# Keys are literally just items in the Sylladex
# But it makes more sense calling them keys in the context of changing between rooms
# Which, yknow, usually involves doors lol
export var required_key : String
export var expend_required_key : bool = false
export(Array, String, MULTILINE) var keyfail_dialogue

func _ready():
	inspect_text.text = inspect_title

func _process(_delta):
	interact_hover()

func do_interaction():
	var interface = UI
	if !required_key.empty() and !UI.sylladex.has_item(required_key):
		if !Global.sequence_active and range(keyfail_dialogue.size()).has(0):
			Global.dialogue.trigger_dialogue(keyfail_dialogue)
		return
	
	if expend_required_key:
		interface.sylladex.remove_item(required_key)
	
	if !Global.sequence_active:
		var room_path = "res://Scenes/Rooms/" + target_folder + "/" + room_name + ".tscn"
		Global.start_room_transition(room_path, warp_to)
