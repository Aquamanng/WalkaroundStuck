class_name PopupActionSound
extends CanvasLayer

# Show a popup window. Requires an exit button to actually exit the popup screen.
# Absolutely nothing special.

func do_interaction():
	if Global.sequence_active:
		return
	
	visible = true
	UI.set_interface(false)
	UI.force_inspector("off")
	UI.sylladex.visible = false
	UI.sylladex_open = false
	Global.sequence_active = true
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()

func _on_Exit_pressed():
	Global.sequence_active = false
	visible = false
	UI.set_interface(true)
	$AudioStreamPlayer.stop()
