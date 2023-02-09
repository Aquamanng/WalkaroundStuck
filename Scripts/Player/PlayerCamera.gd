extends Camera2D

# Just a zoom for the player camera. Scroll in, zoom in. Scroll out, zoom out.
# That's all there really is to say on the matter.
# // TODO: Have the camera independent/not a child of the player so it can move to other look-at targets? \\

export var inner_view : Vector2
export var outer_view : Vector2
var target_view : Vector2
export var zoom_speed : float

func _ready():
	target_view = inner_view

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					target_view = inner_view
				BUTTON_WHEEL_DOWN:
					target_view = outer_view

func _process(delta):
	zoom = lerp(zoom, target_view, zoom_speed * delta)
