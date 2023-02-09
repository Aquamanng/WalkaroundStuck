class_name Captchable
extends Interactable

# Captchables are the main "puzzle element" that I added, along with the Sylladex.
# When the Inspector is set to Captchable Mode, the player can click on a Captchable
# to captchalogue it in their Sylladex and store it for later use. Interactables can require a Captchable item in the sylladex to be able to be interacted with.
# of course, if the sylladex is full, the player won't be able to captchalogue more items.

# Item name is used to keep track of items when stored in Sylladex
# and checked against interactions that require that certain item.
export var item_name : String
export var sprite : Texture
# When an item is clicked on in a Captcha slot in the Sylladex, this will pop up in the dialogue box.
export(Array, String, MULTILINE) var description
export var captcha_target : NodePath

func _ready():
	inspect_text.text = inspect_title
	if Global.sylladex.has_item(item_name):
		visible = false
		var captcha_obj = get_node(captcha_target)
		captcha_obj.visible = false

func _process(_delta):
	interact_hover()

# This will store the item in the Sylladex assuming the Sylladex is not full.
# Otherwise have the dialogue box yell at you maybe
func do_interaction():
	Global.sylladex.add_item(item_name, description, sprite)
	visible = false
	assert (get_node(captcha_target), "captcha_target is invalid on " + name + "! You should probably fix that.")
	var captcha_obj = get_node(captcha_target)
	captcha_obj.visible = false
