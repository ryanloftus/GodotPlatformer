extends Node2D

onready var camera = $Camera
onready var player = $Player

onready var screen_size = get_viewport_rect().size

var CAMERA_SPEED = 0.1
# Camera is centered, so this places the player at 1/2 - 1/6 = 1/3 on the screen
onready var CAMERA_DISTANCE_FROM_PLAYER = screen_size.y / 6


func _on_Player_collided_with_floor() -> void:
	print("Game Over!")
	get_tree().change_scene("res://scenes/GameOver.tscn")


func update_camera():
	var target_y = player.position.y - CAMERA_DISTANCE_FROM_PLAYER
	camera.position.y = lerp(camera.position.y, target_y, CAMERA_SPEED)


func _process(dt):
	update_camera()
