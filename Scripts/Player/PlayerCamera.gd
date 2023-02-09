extends Camera2D

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
