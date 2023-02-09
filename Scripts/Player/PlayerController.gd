class_name player_controller
extends KinematicBody2D

# Player movement. Not much to say really.
# Acceleration/deceleration for fine-tuning the 'feel' of the movement.
# Adjusts the sprite's H-Flip depending on input, and also does some animations accordingly.
# Also changes to backfacing sprites if the player's input is up or down.
# The animation names are hardcoded but you could easily add a few export strings if you wanted to.
# Really not worth it though probably lol

export var move_speed : float
export var acceleration : float
export var deceleration : float

var input_vector : Vector2
var move_velocity : Vector2

var back_sprite : bool = false

onready var sprite = $CharSprite
onready var animator = $PlayerAnimator
# For some reason I have a reference to the player camera here. This isn't used anywhere lol.
# Player camera will eventually be independent from the main player, probably, so I can have the camera
# move to focus on different areas of the room for cinematics and other shit.
onready var cam = $PlayerCam

func _process(_delta):
	if !Global.sequence_active:
		if Input.is_action_pressed("move_left"):
			sprite.flip_h = true
		elif Input.is_action_pressed("move_right"):
			sprite.flip_h = false
		
		if Input.is_action_pressed("move_up"):
			back_sprite = true
		elif Input.is_action_pressed("move_down"):
			back_sprite = false

# Movement is disabled if a dialogue sequence or other sequence is currently active according to the Global class.
func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and !Global.sequence_active and !Global.dialog_active:
		move_velocity = move_velocity.move_toward(input_vector * move_speed, acceleration * delta)
		
		if !back_sprite:
			animator.play("Walk")
		else:
			animator.play("BackWalk")
		
	elif input_vector == Vector2.ZERO or Global.sequence_active or Global.dialog_active:
		move_velocity = move_velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
		if !back_sprite:
			animator.play("Idle")
		else:
			animator.play("BackIdle")
	
	move_and_slide(move_velocity * move_speed)
