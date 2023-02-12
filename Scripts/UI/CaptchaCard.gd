class_name CaptchaCard
extends Control

var current_item : CaptchaItem
onready var item_sprite = $CardButton/ItemSprite
onready var anim_player : AnimationPlayer = $AnimationPlayer

var card_highlighted : bool = false
onready var sylladex = Global.sylladex

func _on_mouse_entered():
	anim_player.play("Hover")
	if current_item != null:
		sylladex.name_display.text = current_item.item_name

func _on_mouse_exited():
	sylladex.name_display.text = ""
	anim_player.play("RESET")

func _on_CardButton_pressed() -> void:
	if current_item != null:
		Global.dialogue.trigger_dialogue(current_item.item_description)
