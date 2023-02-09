class_name Inspectable
extends Interactable

# Inspectables are the baseline Interactable that I've used most prevalently in the project.
# It's just a way of clicking on a certain item/area in a room and showing some dialogue like the classic walkaround flashes in Homestuck.
# Inspectables can require a certain Captchable item in the Sylladex in order to trigger the interaction,
# and can also trigger additional interactions afterward.

export(Array, String, MULTILINE) var dialogue = ["You successfully inspect the INSPECTABLE."]
# if null, end interaction like normal
export(Array, NodePath) var next_interactions = []

# If blank, no item required
# If required_item isn't in the player's Sylladex at the time of interaction,
# trigger a dialogue sequence using itemfail_dialogue and then return.
export var required_item : String
export var expend_required_item : bool = false
export(Array, String, MULTILINE) var itemfail_dialogue

func _ready():
	inspect_text.text = inspect_title

func _process(_delta):
	interact_hover()

func do_interaction():
	if !required_item.empty() and !UI.sylladex.has_item(required_item):
		if !Global.dialog_active and range(itemfail_dialogue.size()).has(0):
			Global.dialogue.trigger_dialogue(itemfail_dialogue)
		return
	
	if range(dialogue.size()).has(0):
		if !Global.dialog_active:
			Global.dialogue.trigger_dialogue(dialogue)
	else:
		pass
	
	if expend_required_item:
		UI.sylladex.remove_item(required_item)
	
	if range(next_interactions.size()).has(0):
		for i in next_interactions:
			var interaction = get_node(i)
			if interaction.has_method("do_interaction"):
				interaction.do_interaction()
			else:
				printerr("WARNING: next_interaction @" + interaction.name + "doesn't appear to have a valid interaction method attached to it.")
