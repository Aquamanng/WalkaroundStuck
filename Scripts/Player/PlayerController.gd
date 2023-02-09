class_name player_controller
extends KinematicBody2D

export var move_speed : float
export var acceleration : float
export var deceleration : float

var input_vector : Vector2
var move_velocity : Vector2

var back_sprite : bool = false

onready var sprite = $CharSprite
onready var animator = $PlayerAnimator
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

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and !Global.sequence_active:
		move_velocity = move_velocity.move_toward(input_vector * move_speed, acceleration * delta)
		
		if !back_sprite:
			animator.play("Walk")
		else:
			animator.play("BackWalk")
		
	elif input_vector == Vector2.ZERO or Global.sequence_active:
		move_velocity = move_velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
		if !back_sprite:
			animator.play("Idle")
		else:
			animator.play("BackIdle")
	
	move_and_slide(move_velocity * move_speed)
