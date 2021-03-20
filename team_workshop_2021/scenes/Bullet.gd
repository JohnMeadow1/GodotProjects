extends RigidBody2D
class_name Bullet


onready var sprite := $Sprite

func _ready():
	pass
	
func _process(delta):
	sprite.rotation = linear_velocity.angle()
