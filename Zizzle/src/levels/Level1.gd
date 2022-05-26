extends Node2D

onready var camera = $Camera
onready var player = $Player
onready var roof = $Roof

onready var screen_size = get_viewport_rect().size


var CAMERA_SPEED = 0.1
onready var ROOF_CAMERA_OFFSET = 50 - screen_size.y / 2
# Camera is centered, so this places the player at 1/2 - 1/6 = 1/3 on the screen
onready var CAMERA_DEFAULT_PLAYER_DISTANCE = screen_size.y / 6
# This places the player at 1/2 - 1/4 = 1/4 on the screen
onready var CAMERA_DOWN_DISTANCE = screen_size.y / 4


func _on_Player_collided_with_floor() -> void:
	print("Game Over!")
	get_tree().change_scene("res://scenes/GameOver.tscn")


func new_camera_pos(dt: float, camera_pos: Vector2, player_pos: Vector2) -> Vector2:
	var down = Input.is_action_pressed("down")
	
	var target_y
	if down:
		target_y = player_pos.y + CAMERA_DOWN_DISTANCE
	else:
		target_y = player_pos.y - CAMERA_DEFAULT_PLAYER_DISTANCE
	
	target_y = max(target_y, roof.position.y - ROOF_CAMERA_OFFSET)
	
	return Vector2(0.0, lerp(camera_pos.y, target_y, CAMERA_SPEED * dt * 60))


func _process(dt):
	camera.position = new_camera_pos(dt, camera.position, player.position)
 
