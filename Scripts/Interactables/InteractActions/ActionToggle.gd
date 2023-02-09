class_name ToggleAction
extends Node2D

# Toggles an array of nodes to be active/visible or inactive.
# Good for continuing sequences by enabling the succeeding sequence nodes after having the required item to trigger it or something.
# An example is having one Inspectable for when a Totem Lathe is inactive, and requires a Cruxite Dowel in the player's Sylladex to interact with it.
# Then that Inspectable is disabled while a Captchable is enabled to allow the player to grab the Carved Totem, yadda yadda.

export(Array, NodePath) var disable_targets = []
export(Array, NodePath) var enable_targets = []

func do_interaction():
	if range(disable_targets.size()).has(0):
		for target in disable_targets:
			var disable_node = get_node(target)
			disable_node.visible = false
	
	if range(enable_targets.size()).has(0):
		for target in enable_targets:
			var enable_node = get_node(target)
			enable_node.visible = true
