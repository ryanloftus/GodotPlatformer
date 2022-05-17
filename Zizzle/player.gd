extends RigidBody2D

export var horiz_accel = 100
export var max_horiz_vel = 500
export var jump_power = 300

var screen_size
export var start_position = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	position = start_position

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	var step = state.get_step()
	
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
	
	if jump:
		velocity.y = -jump_power
	
	velocity += state.get_total_gravity() * step
	state.set_linear_velocity(velocity)
	
func _physics_process(delta):
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
