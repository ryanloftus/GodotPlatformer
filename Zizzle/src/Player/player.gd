extends KinematicBody2D

export var horiz_accel = 100
export var max_horiz_vel = 500
export var jump_power = 1000
export var gravity = 50

var velocity = Vector2()
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func get_inputs(delta):
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("jump")
	
	# Accelerate to max velocity if direction is held
	if left:
		velocity.x = max(velocity.x - horiz_accel, -max_horiz_vel)
	elif right:
		velocity.x = min(velocity.x + horiz_accel, max_horiz_vel)
	else:
		# Decelerate when not moving
		if velocity.x < 0.0:
			velocity.x = max(velocity.x + horiz_accel, 0.0)
		elif velocity.x > 0.0:
			velocity.x = min(velocity.x - horiz_accel, 0.0)
	
	if jump and is_on_floor():
		velocity.y = -jump_power
		
	if not is_on_floor():
		velocity.y += gravity
	
func _physics_process(delta):
	get_inputs(delta)
	move_and_slide(velocity, Vector2.UP)