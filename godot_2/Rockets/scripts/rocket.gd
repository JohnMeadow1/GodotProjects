
extends Node2D

var position            = Vector2( )
var velocity            = Vector2( 1,0 ) 
var orientation         = 0
var angular_v           = 0

var direction           = Vector2( )

var player              = null
var target              = Vector2()
var active              = true
var initialization      = true
var timer               = 0

func _fixed_process(delta):
	if (initialization == true):
		
		timer += delta
		
		velocity += Vector2(cos (orientation), -sin(orientation)) * clamp(timer-0.25, 0, 1) * 0.25
		velocity *= 0.965
		set_pos( get_pos() + velocity )
		get_node("Node2D").set_rot(orientation)
		if (timer > 0.5):
			initialization = false
		pass
	elif (active):
		target    = player.get_pos() - get_pos()
		var dot   = target.x * direction.x + target.y * direction.y
		var cross = target.x * direction.y - target.y * direction.x
		var distance_to_target = target.length()
		if ( dot > 0 ):
			var t = clamp( distance_to_target + 20, 0, 100 ) / 100
			var result = direction * (t) + velocity * (1-t)
			dot   = target.x * result.x + target.y * result.y
			cross = target.x * result.y - target.y * result.x
			var time_to_target = distance_to_target / clamp(velocity.length(), 0.1, 100)
			target    += player.velocity * clamp(time_to_target, 0, 400)

			dot   = target.x * velocity.x + target.y * velocity.y
			cross = target.x * velocity.y - target.y * velocity.x

		var angle_to_target = atan2( cross, dot )
		
#		if ( abs(angular_v) < abs(angle_to_target) ):
		angular_v =  clamp( angle_to_target, -0.4, 0.4 )

#		orientation += angular_v * clamp(target.length(), 120, 300)/1200 
#		orientation += angular_v * clamp(target.length(), 1, 200)/2000
		if( cross > 0 && angular_v > 0 ): 
			orientation += angular_v * 0.1
		elif( cross > 0 && angular_v < 0 ):
			orientation -= angular_v * 0.1
		elif( cross < 0 && angular_v > 0 ): 
			orientation -= angular_v * 0.1
		elif( cross < 0 && angular_v < 0 ):
			orientation += angular_v * 0.1
	
		direction    = Vector2( cos(orientation), - sin(orientation) )
#		velocity    += 0.6 * ( 1 - clamp( abs(angular_v), 0, 0.4 ) ) * direction * (1 - clamp( abs(angle_to_target) / (PI)+0.1, 0.0, 0.75 ))
		velocity    += 0.6 * direction * (1 - clamp( abs(angle_to_target) / (PI)+0.1, 0.0, 0.75 ))

		var force = Vector2()
		for rocket in get_parent().get_children():
			var distance = rocket.get_pos() - get_pos()
			var dist_length = distance.length_squared()
			if ( distance.length_squared() > 1 ):
				force -= distance.normalized() * 100 / distance.length_squared()
		velocity += force
		velocity *= 0.95
		
		
		get_node("Node2D").set_rot(orientation)
		if ((player.get_pos() - get_pos()).length()< 30):
			destroy()
#			
		var asteroid = get_node("../../Asteroid").get_pos() - get_pos()
		if (asteroid.length()< 40):
			destroy()
	else:
		timer += delta
		if (timer >0.4):
			queue_free()

	set_pos( get_pos() + velocity )
	update()
	
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
func _draw():
	draw_line( Vector2(), target,      Color(0.5, 0.5, 0.5, 0.5) )
	draw_line( Vector2(), velocity*100, Color(1,0,0,0.5) )
	draw_circle( velocity*100 ,5 , Color(1, 0, 0, 0.5) )
	draw_circle( target ,5 , Color(0.5, 0.5, 0.5, 0.5) )
	pass

func _ready():
	player = get_node("../../Spaceship")
	set_fixed_process(true)


