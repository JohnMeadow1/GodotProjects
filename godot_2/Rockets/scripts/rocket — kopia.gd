
extends Node2D

var position            = Vector2( )
var velocity            = Vector2( ) 
var orientation         = 0
var angular_v           = 0

var direction           = Vector2( )

var player              = null
var target              = Vector2()
var ratation_to_target  = 0
var active              = true
var timer               = 0

func _fixed_process(delta):
	if (active):
		target =  player.get_pos() - get_pos()
		var time_to_target = clamp(target.length(), 0, 400) / clamp (velocity.length(),0.001,100)
		target =  (player.get_pos() + player.velocity * time_to_target ) - get_pos()
		var dot   =  target.x * velocity.x + target.y * velocity.y 
		var cross =  target.x * velocity.y - target.y * velocity.x 
		var angle_to_target = atan2(cross, dot)
		
		angular_v = clamp(angle_to_target/20, -0.2, 0.2)
		orientation += angular_v
		
		direction   = Vector2( cos (orientation), -sin (orientation) )
		velocity += direction * (0.5-clamp(abs(angle_to_target/10), 0.00, 0.49))
		velocity *= 0.95
		var force = Vector2()
		for rocket in get_parent().get_children():
			var distance = rocket.get_pos() - get_pos()
			if (distance.length_squared() > 1):
				force -= ( distance.normalized() )/distance.length()
		velocity += force
		get_node("Node2D").set_rot(orientation)
		if (target.length()< 30):
			destroy()
	else:
		timer += delta
		if (timer >0.4):
			queue_free()

	set_pos( get_pos() + velocity )
#	update()
	
func destroy():
	active = false
	get_node("Node2D/AnimationPlayer").play("boom")
	
func reset():
	set_pos( Vector2(rand_range(1,700),rand_range(1,400)) )
	get_node("Node2D/AnimationPlayer").play("Active")
	get_node("Node2D/warhead").set_hidden(false)
	get_node("Node2D/fire").set_hidden(false)
	active = true
	timer = 0
	angular_v = 0
	velocity = Vector2()
#func _draw():
#	draw_line(Vector2(), target,      Color(1,1,1,0.5))
#	draw_line(Vector2(), velocity*10, Color(1,0,0,0.5))
#	pass
	
func _ready():
	player = get_node("../../Spaceship")
	set_fixed_process(true)


