class_name Sylladex
extends Node2D

# Kinda-sorta functions like the actual Sylladex. Modus behavior is hardcoded, sorry not sorry
# Modus behavior will be Stack (sort of, doesnt reshuffle when item is removed), but nothing actually will get ejected
# If you captchalogue an item and your Sylladex is full, you wont captchalogue it until you use an item
# Used items are destroyed, or "expended", though that can be toggled on a per-interaction basis
# Primarily just a way of carrying around items like in your average point and click adventure to solve puzzles n whatnot
export(Array, NodePath) var cards = []
var full_dialogue = ["You can't CAPTCHALOGUE anything right now! Your SYLLADEX is full!"]
onready var name_display = $ItemNameDisplay

# Looks a little messy but this is how I add the little "tickback" that captchaloguing is famous for
# I could do it a little more elegantly than this probably but this is fine lol
func add_item(item : String, dialog, sprite : Texture):
	for c in cards:
		var card = get_node(c)
		if card.current_item.empty():
			Global.sequence_active = true
			# Wanted to have different delay times depending on if the sylladex was already opened or not
			# A very brief pause if already opened, a lesser pause if not, but still one that mimics a "freezeframe" mid-game
			if !UI.sylladex_open:
				UI.open_sylladex()
				yield(get_tree().create_timer(0.35), "timeout")
			else:
				yield(get_tree().create_timer(0.15), "timeout")
			
			card.current_item = item
			card.current_description = dialog
			card.item_sprite.texture = sprite
			card.position += card.hover_pos
			yield(get_tree().create_timer(0.04), "timeout")
			card.position = card.normal_pos
			yield(get_tree().create_timer(0.4), "timeout")
			if !UI.sylladex_open:
				UI.close_sylladex()
			
			Global.sequence_active = false
			return
	
	Global.dialogue.trigger_dialogue(full_dialogue)

func remove_item(target : String):
	for c in cards:
		var card = get_node(c)
		if card.current_item.to_upper() == target.to_upper():
			Global.sequence_active = true
			# Wanted to have different delay times depending on if the sylladex was already opened or not
			# A very brief pause if already opened, a lesser pause if not, but still one that mimics a "freezeframe" mid-game
			if !UI.sylladex_open:
				UI.open_sylladex()
				yield(get_tree().create_timer(0.35), "timeout")
			else:
				yield(get_tree().create_timer(0.15), "timeout")
			
			card.current_item = ""
			card.current_description = []
			card.item_sprite.texture = null
			card.position += card.hover_pos
			yield(get_tree().create_timer(0.04), "timeout")
			card.position = card.normal_pos
			yield(get_tree().create_timer(0.4), "timeout")
			if !UI.sylladex_open:
				UI.close_sylladex()
			
			Global.sequence_active = false
			return

func has_item(target : String) -> bool:
	for c in cards:
		var card = get_node(c)
		if !card.current_item.empty() and card.current_item.to_upper() == target.to_upper():
			return true
	
	return false
