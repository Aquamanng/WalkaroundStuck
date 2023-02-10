class_name CaptchaCard
extends Sprite

var current_item : String
var current_description = []
onready var item_sprite = $ItemSprite

export var hover_pos : Vector2
onready var normal_pos : Vector2 = position

var card_highlighted : bool = false
var normal_sprite = preload("res://Sprites/UI/Sylladex/CaptchaCard.png")
var pressed_sprite = preload("res://Sprites/UI/Sylladex/CaptchaCardHovered.png")
onready var sylladex = Global.sylladex

func _input(event):
	if event.is_action_pressed("submit") and card_highlighted:
		texture = pressed_sprite
	
	if event.is_action_released("submit") and card_highlighted:
		if !current_item.empty():
			Global.dialogue.trigger_dialogue(current_description)
		
		texture = normal_sprite

func _process(_delta):
	if !card_highlighted:
		texture = normal_sprite

func _on_Area2D_mouse_entered():
	card_highlighted = true
	position += hover_pos
	
	if current_item != "":
		sylladex.name_display.text = current_item

func _on_Area2D_mouse_exited():
	card_highlighted = false
	position = normal_pos
	sylladex.name_display.text = ""
