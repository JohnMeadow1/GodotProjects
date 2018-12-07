
extends Node2D

var player = null
var bullet = null
var rocket = null
var target = Vector2()
var orientation = 0
var fire_timer = 1 
var rocket_timer = 0 
var direction = Vector2()
var salvo_size = 3
var salvo_count = 0
var is_alive = true

func _fixed_process(delta):
	target = player.get_pos() - get_pos()
	set_pos( get_pos() + target.normalized() )
	orientation = atan2( -target.y, target.x)
	get_node("Sprite").set_rot(orientation)
	direction = Vector2 ( cos (orientation), -sin (orientation) )
	
	fire_timer += delta
	rocket_timer += delta
	if (fire_timer >= 1):
		fire_timer = 0
		var new_bullet = bullet.instance()
		new_bullet.id = 1
		new_bullet.set_pos( get_pos() )
		new_bullet.set_rot( orientation )
		new_bullet.velocity = target.normalized() + (direction + Vector2(rand_range(-0.1,0.1),rand_range(-0.1,0.1))) * 10
		get_node("../bullets").add_child( new_bullet )
	if (rocket_timer > 5):
		fire_rockets()
			
func _ready():
	bullet = load("res://scenes/bullet.tscn")
	rocket = load("res://scenes/rocket.tscn")
	player = get_node("../Spaceship")
	set_fixed_process(true)
	
#func _draw():
#	draw_line(Vector2(), target, Color (0,0,0))
func fire_rockets():
	if (salvo_size>salvo_count):
		if (rocket_timer > 5 + salvo_count * 0.25):
			salvo_count += 1
			var new_rocket = rocket.instance()
			new_rocket.set_pos( get_pos() )
			new_rocket.orientation = orientation
			new_rocket.velocity = direction + direction.tangent()*2
			get_node("../rockets").add_child( new_rocket )
			new_rocket = rocket.instance()
			new_rocket.set_pos( get_pos() )
			new_rocket.orientation = orientation
			new_rocket.velocity = direction - direction.tangent()*2
			get_node("../rockets").add_child( new_rocket )
	else:
		rocket_timer = 0
		salvo_count  = 0
func destroy():
	get_node("Sprite").set_hidden(true)
	set_fixed_process(false)
	is_alive = false