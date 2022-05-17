extends KinematicBody2D


var velocity = Vector2()
var horiz_accel = 100
var max_horiz_vel = 500

var screen_size
export var start_position = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	position = start_position

func get_movement_inputs():
	
	# Accelerate to max velocity if direction is held
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - horiz_accel, -max_horiz_vel)
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + horiz_accel, max_horiz_vel)
	
	# Decelerate when not moving
	else:
		if velocity.x < 0.0:
			velocity.x = max(velocity.x + horiz_accel, 0.0)
		elif velocity.x > 0.0:
			velocity.x = min(velocity.x - horiz_accel, 0.0)
	
	# To add other inputs, you have to go to Project -> Project Settings ->
	# Input Map tab, and add an action with a descriptor such as "left" or "up"


func _physics_process(delta):
	get_movement_inputs()
	velocity = move_and_slide(velocity)
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
