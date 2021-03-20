extends StaticBody2D
class_name Tank

export(int) var max_hp = 2
var current_hp = 0

func _ready() ->void:
	current_hp = max_hp

func damage(value):
	current_hp -= value
	if current_hp <= 0:
		queue_free()
