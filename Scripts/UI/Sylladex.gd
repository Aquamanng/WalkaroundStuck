class_name Sylladex
extends Node2D

# Kinda-sorta functions like the actual Sylladex. Modus behavior is hardcoded, sorry not sorry
# Modus behavior will be Stack (sort of, doesnt reshuffle when item is removed), but nothing actually will get ejected
# If you attempt to captchalogue an item and your Sylladex is full, you wont captchalogue it until you use an item
# Used items are destroyed, or "expended", though that can be toggled on a per-interaction basis
# Primarily just a way of carrying around items like in your average point and click adventure to solve puzzles n whatnot
onready var cards = $Background/CardsContainer.get_children()
var full_dialogue = ["You can't CAPTCHALOGUE anything right now! Your SYLLADEX is full!"]
onready var name_display = $ItemNameDisplay

# Loops through all cards to check if their current_item string is empty or not.
# If empty, it'll shove the item into the card with a nice little fancy pop-in animation.
# It's all smoke and mirrors, you're not even actually captchaloguing an actual item!
# Just some strings and a sprite.
# // TODO: Convert it into a custom Resource instead to alleviate that mess? \\
# This doesn't look the most elegant but it works fine. Good enough for me!
func add_item(item : String, dialog, sprite : Texture):
	for card in cards:
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
			card.anim_player.play("Hover")
			yield(get_tree().create_timer(0.04), "timeout")
			card.anim_player.play("RESET")
			yield(get_tree().create_timer(0.04), "timeout")
			if !UI.sylladex_open:
				UI.close_sylladex()
			
			Global.sequence_active = false
			return
	
	# If we loop through all the cards then that means they're all occupied
	# so we'll berate the player instead lol
	Global.dialogue.trigger_dialogue(full_dialogue)

# Same as adding an item, loop through all the cards; if its current_item matches the target string,
# then we just get rid of the item. Gone. Reduced to atoms.
func remove_item(target : String):
	for card in cards:
		if card.current_item.to_upper() == target.to_upper():
			card.current_item = ""
			card.current_description = []
			card.item_sprite.texture = null
			return

# You probably know the drill by now.
# Loop through all the cards; if it has the target string as its current_item,
# then return true. Otherwise return false.
func has_item(target : String) -> bool:
	for card in cards:
		if !card.current_item.empty() and card.current_item.to_upper() == target.to_upper():
			return true
	
	return false
