extends Area2D

enum InspectorMode { INSPECTABLE, CAPTCHABLE }
export(InspectorMode) var inspect_mode
var inspector_active : bool = true

func _process(delta):
	position = get_global_mouse_position()

func _on_InspectableDetector_area_entered(area):
	if inspect_mode == InspectorMode.INSPECTABLE:
		if area.is_in_group("Inspectables"):
			area.get_child(1).visible = true
	elif inspect_mode == InspectorMode.CAPTCHABLE:
		if area.is_in_group("Captchables"):
			area.get_child(1).visible = true

func _on_InspectableDetector_area_exited(area):
	if inspect_mode == InspectorMode.INSPECTABLE:
		if area.is_in_group("Inspectables"):
			area.get_child(1).visible = false
	elif inspect_mode == InspectorMode.CAPTCHABLE:
		if area.is_in_group("Captchables"):
			area.get_child(1).visible = false
