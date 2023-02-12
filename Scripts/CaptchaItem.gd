class_name CaptchaItem
extends Resource

# The name will show up in the top-right of the Sylladex when you mouse over
# the Captcha Card with the item in it
export var item_name : String
# The sprite that will show up inside a Captcha Card when captchalogued
export var item_sprite : Texture
export(Array, String, MULTILINE) var item_description = []
