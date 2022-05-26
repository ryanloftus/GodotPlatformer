extends Node2D

onready var camera = $Camera
onready var player = $Player
onready var roof = $Roof

onready var screen_size = get_viewport_rect().size


var CAMERA_SPEED = 0.1
export var ROOF_DISPLAY_HEIGHT = 50  # How much of the roof to show
onready var ROOF_CAMERA_OFFSET = camera_adjust_y(ROOF_DISPLAY_HEIGHT)
onready var CAMERA_DEFAULT_PLAYER_DISTANCE = camera_adjust_y((2.0/3.0) * screen_size.y)
onready var CAMERA_DOWN_DISTANCE = camera_adjust_y((3.0/4.0) * screen_size.y)


# Changes a y-value relative to the top of the camera to a y-value in the world.
# For example, passing 0 will return the y-value of the top of the camera in the world.
func camera_adjust_y(y: float) -> float:
	return camera_adjust(Vector2(0, y)).y


# Changes a position relative to the top left of the camera to a position in the world.
# For example, passing (0, 0) will return the position of the top left of the camera in the world.
func camera_adjust(pos: Vector2) -> Vector2:
	return pos - camera.position - screen_size / 2


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
 
