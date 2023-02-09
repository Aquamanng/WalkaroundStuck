extends Area2D

# The Inspector determines which Interactables the player can mouse-over and click on.
# INSPECTABLE mode only allows for Inspectables, which are usually just dialogue triggers.
# CAPTCHABLE mode only allows for using Captchables, letting the player captchalogue an item in their Sylladex.

enum InspectorMode { INSPECTABLE, CAPTCHABLE }
export(InspectorMode) var inspect_mode
# if false, the hint popup sprites don't appear and won't let the player interact with anything
var inspector_active : bool = true

func _process(delta):
	position = get_global_mouse_position()

# get_child(1) refers to the HintSprite on all Interactables.
# These two methods below are actually redundant because InteractableBase already does the same thing 
# and I had no idea until I went through on a code commenting pass
# to include some ramblings about how the code works. Guess I don't entirely know my own code, huh?
# Fun stuff! God help us all.

#func _on_InspectableDetector_area_entered(area):
#	if inspect_mode == InspectorMode.INSPECTABLE:
#		if area.is_in_group("Inspectables"):
#			area.get_child(1).visible = true
#	elif inspect_mode == InspectorMode.CAPTCHABLE:
#		if area.is_in_group("Captchables"):
#			area.get_child(1).visible = true
#
#func _on_InspectableDetector_area_exited(area):
#	if inspect_mode == InspectorMode.INSPECTABLE:
#		if area.is_in_group("Inspectables"):
#			area.get_child(1).visible = false
#	elif inspect_mode == InspectorMode.CAPTCHABLE:
#		if area.is_in_group("Captchables"):
#			area.get_child(1).visible = false
