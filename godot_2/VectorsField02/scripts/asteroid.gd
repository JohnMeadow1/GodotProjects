
extends Node2D

var position = Vector2()
func _ready():
	set_fixed_process(true)
	# Initialization here
	pass
func _fixed_process(delta):
	
	var player = get_node("../Spaceship").get_pos()
	
#	set_pos(get_pos()+((player - get_pos() ).normalized()*2))
	
	pass


