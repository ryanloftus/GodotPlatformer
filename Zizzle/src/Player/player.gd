extends KinematicBody2D

export var horiz_accel = 100
export var max_horiz_vel = 500
export var jump_power = 1000
export var min_jump_power = 100
export var gravity = 46
export var terminal_velocity = 1000

var COYOTE_TIME = 0.07  # Slightly more than four frames
var coyote_time_timer = COYOTE_TIME + 1.0

var JUMP_BUFFER = 0.07  # Slightly more than four frames
var jump_buffer_timer = JUMP_BUFFER + 1.0

var JUMP_STOP_GRAVITY_MULTIPLIER = 2.4
var jump_stop_active = false

var velocity = Vector2()
var screen_size

signal collided_with_floor

func _ready():
	screen_size = get_viewport_rect().size
	
func apply_jump(velocity: Vector2) -> Vector2:
	coyote_time_timer = COYOTE_TIME + 1.0  # Disable coyote time
	jump_buffer_timer = JUMP_BUFFER + 1.0  # Disable jump buffer
	velocity.y = -jump_power  # Jump	
	
	return velocity

func update_velocity(delta: float, velocity: Vector2) -> Vector2:
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_held = Input.is_action_pressed("jump")
	var jump_stopped = Input.is_action_just_released("jump")
	
	# Accelerate to max velocity if direction is held
	if left:
		velocity.x -= horiz_accel
	elif right:
		velocity.x += horiz_accel
	else:
		# Decelerate when not moving
		if velocity.x < 0.0:
			velocity.x += min(horiz_accel, abs(velocity.x))
		elif velocity.x > 0.0:
			velocity.x += max(-horiz_accel, -abs(velocity.x))
		
	if is_on_floor():
		velocity.y = 0.0
		coyote_time_timer = 0.0
	
	if jump_stopped && velocity.y < 0.0:
		# allows for variable jump heights
		jump_stop_active = true
	
	# Deactivate jump stopping after the arc is complete
	if jump_stop_active and velocity.y > 0.0:
		jump_stop_active = false
	
	# If you press jump, start the jump buffer timer
	if jump_pressed:
		jump_buffer_timer = 0.0
		
	# If you touch the ground before the jump buffer runs out, jump
	if jump_buffer_timer < JUMP_BUFFER:
		jump_buffer_timer += delta
		if is_on_floor() or coyote_time_timer < COYOTE_TIME:
			velocity = apply_jump(velocity)
			print(velocity)
		
	if not is_on_floor():
		# Bonk against ceiling
		if is_on_ceiling():
			velocity.y = 0.0
		
		# Increment coyote time
		if coyote_time_timer < COYOTE_TIME:
			coyote_time_timer += delta
	
	if jump_stop_active:
		velocity.y += gravity * JUMP_STOP_GRAVITY_MULTIPLIER
	else:
		velocity.y += gravity
	
	velocity.x = clamp(velocity.x, -max_horiz_vel, max_horiz_vel)
	velocity.y = clamp(velocity.y, -jump_power, terminal_velocity)
	return velocity

func check_for_ground_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Ground":
			emit_signal("collided_with_floor")
	
func _physics_process(delta):
	velocity = update_velocity(delta, velocity)
	move_and_slide(velocity, Vector2.UP)
	check_for_ground_collision()
	
	
