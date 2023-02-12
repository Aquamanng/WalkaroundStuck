class_name Captchable
extends Interactable

# Captchables are the main "puzzle element" that I added, along with the Sylladex.
# When the Inspector is set to Captchable Mode, the player can click on a Captchable
# to captchalogue it in their Sylladex and store it for later use. Interactables can require a Captchable item in the sylladex to be able to be interacted with.
# of course, if the sylladex is full, the player won't be able to captchalogue more items.

# Drag in a CaptchaItem Resource to this field.
export var item_path : Resource
var captcha_item : CaptchaItem
# This NodePath should point to the sprite in the actual environment that will disappear
# when the item is captchalogued.
export var captcha_target : NodePath

func _ready():
	captcha_item = load(item_path.resource_path)
	
	inspect_text.text = inspect_title
	if Global.sylladex.has_item(captcha_item.item_name):
		visible = false
		var captcha_obj = get_node(captcha_target)
		captcha_obj.visible = false

func _process(_delta):
	interact_hover()

# This will store the item in the Sylladex assuming the Sylladex is not full.
# Otherwise have the dialogue box yell at you maybe
func do_interaction():
	Global.sylladex.add_item(captcha_item)
	visible = false
	assert (get_node(captcha_target), "captcha_target is invalid on " + name + "! You should probably fix that.")
	var captcha_obj = get_node(captcha_target)
	captcha_obj.visible = false
