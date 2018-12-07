
extends Node2D

var velocity = Vector2(0,0)
var timeout = 0 

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timeout += delta
	if (timeout>2):
		queue_free()
	set_pos( get_pos() + velocity )


