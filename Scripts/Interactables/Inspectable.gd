class_name Inspectable
extends Interactable

export(Array, String, MULTILINE) var dialogue = ["You successfully inspect the INSPECTABLE."]
# if null, end interaction like normal
export(Array, NodePath) var next_interactions = []

# If blank, no key required
# Store keys in level root node in an array, then just check that array to see if stored keys match this requirement
# If key isnt stored yet, dont do normal action and just print fail dialogue
export var required_item : String
export var expend_required_item : bool = false
export(Array, String, MULTILINE) var itemfail_dialogue

var interacted : bool = false

func _ready():
	inspect_text.text = inspect_title

func _process(_delta):
	interact_hover()
	
	if interacted and !Global.dialog_active and expend_required_item:
		UI.sylladex.remove_item(required_item)
		# So it doesn't fuckin stroke out every goddamn frame afterward lol
		interacted = false

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
	
	if range(next_interactions.size()).has(0):
		for i in next_interactions:
			var interaction = get_node(i)
			if interaction.has_method("do_interaction"):
				interaction.do_interaction()
			else:
				printerr("WARNING: next_interaction @" + interaction.name + "doesn't appear to have a valid interaction method attached to it.")
	
	interacted = true
