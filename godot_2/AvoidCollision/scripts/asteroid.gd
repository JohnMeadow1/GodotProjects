
extends Node2D

var position = Vector2()
var velocity = Vector2()
var acceleratio = Vector2()
var angleToTarget = 0.0

var target   = Vector2()
var parent   = null
var player   = null
var radius   = 10
var mass     = 20
var speed    = 4

func _ready():
	randomize()
	set_fixed_process(true)
	parent = get_parent().get_parent()
	player = get_node("../Spaceship")
	
	set_pos(Vector2(rand_range(0,800),rand_range(0,600)))
	generate_target()

	pass
func _fixed_process(delta):
	
	position = get_pos()
	position += parent.calculate_vector( position )
	position += ((player.get_pos() - player.orientation * 50 - get_pos() ).normalized() * speed )
	if ((target - position).length_squared() < 2500):
		generate_target()
	set_pos(position)
	
	pass
	
func generate_target():
	target = Vector2(rand_range(0,800),rand_range(0,600))

