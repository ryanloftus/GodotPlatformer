extends KinematicBody2D

export var horiz_accel = 100
export var max_horiz_vel = 500
export var jump_power = 1000
export var min_jump_power = 250
export var gravity = 50

var velocity = Vector2()
var screen_size

signal collided_with_floor

func _ready():
	screen_size = get_viewport_rect().size

func update_velocity(delta: float, velocity: Vector2):
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("jump")
	var jump_stopped = Input.is_action_just_released("jump")
	
	# Accelerate to max velocity if direction is held
	if left:
		velocity.x -= horiz_accel
	elif right:
		velocity.x += horiz_accel
	else:
		# Decelerate when not moving
		if velocity.x < 0.0:
			velocity.x = max(velocity.x + horiz_accel, 0.0)
		elif velocity.x > 0.0:
			velocity.x = min(velocity.x - horiz_accel, 0.0)
	
	velocity.x = clamp(velocity.x, -max_horiz_vel, max_horiz_vel)
	
	if jump and is_on_floor():
		velocity.y = -jump_power
	elif jump_stopped && velocity.y < 0.0:
		# allows for variable jump heights
		velocity.y = max(velocity.y, -min_jump_power)
	
		
	if not is_on_floor():
		velocity.y += gravity
	
	return velocity
	
func _physics_process(delta):
	velocity = update_velocity(delta, velocity)
	move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Ground":
			emit_signal("collided_with_floor")
	
