extends KinematicBody2D


export var climb_speed = -10
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	var target_width = screen_size.x
	var texture_size = $Sprite.texture.get_size()
	
	$Sprite.scale.x = (1 / texture_size.x) * target_width
	
	print(texture_size, screen_size, $Sprite.scale)

func _physics_process(delta):
	move_and_slide(Vector2(0, climb_speed), Vector2.UP)
