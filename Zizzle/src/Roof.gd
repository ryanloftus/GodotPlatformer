extends KinematicBody2D


var MOVE_UP_SPEED = 0.1
onready var target_y = position.y


func _ready():
	pass


func move_up(distance):
	target_y -= distance


func _process(dt):
	var debug_roof_up = Input.is_action_just_pressed("debug_roof_up")
	
	if debug_roof_up:
		move_up(100)
		
	position.y = lerp(position.y, target_y, MOVE_UP_SPEED * dt * 60)
