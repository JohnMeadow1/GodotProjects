extends Node2D

### import the input helper class
var input_states = preload("input_states.gd")

### create input states classes
var state_up    = input_states.new("up")
var state_down  = input_states.new("down")
var state_left  = input_states.new("left")
var state_right = input_states.new("right")
var state_fire  = input_states.new("fire")
var state_afterburner = input_states.new("afterburner")

var btn_up      = null
var btn_down    = null
var btn_left    = null
var btn_right   = null
var btn_fire    = null
var btn_aftburn = null

var line_color1         = Color( 1.0, 0.0, 0.0 )
var line_color2         = Color( 0.0, 1.0,0.0 )

var position            = Vector2( 0, 0 )
var velocity            = Vector2( 0.0, 0.0 ) 
var orientation         = 0
var angular_velocity    = 0

var direction           = Vector2 ( 0.0, 0.0 )
var thrust              = 0
var afterburner_max     = 1
var afterburner         = 1
var bullet              = null

var asteroid            = Vector2 ( 0.0, 0.0 )
var projection          = Vector2 ( 0.0, 0.0 )
var dot                 = 0
var cross               = 0
var gravity             = Vector2 ( )
var mass                = 10000
var fire_timer          = 0 

func get_projection ( V, W ):
	dot        = V.x * W.x + V.y * W.y
	cross      = V.x * W.y - V.y * W.x
	projection = (dot / V.length_squared()) * V

func _fixed_process( delta ):
	process_input( delta )
	
	get_projection ( direction, asteroid )
	
	asteroid = get_node("../Asteroid").get_pos() - position
	
	velocity         = velocity * 0.96
	angular_velocity = angular_velocity * 0.92
	
	if ((projection - asteroid).length()< 100):
		angular_velocity += 0.01/clamp(abs(cross),1,100) *sign(cross)
	
	orientation      = orientation + angular_velocity
	direction        = Vector2 ( cos (orientation), -sin (orientation) )
	
	velocity         = velocity + (direction * thrust)
#	gravity  = mass/asteroid.length_squared()         \
#	           * -asteroid.normalized()
	position         = position + velocity + gravity
	
	display_vectors()
	
func process_input( delta ):
	btn_up    = state_up.check()
	btn_down  = state_down.check()
	btn_left  = state_left.check()
	btn_right = state_right.check()
	btn_fire  = state_fire.check()
	btn_aftburn  = state_afterburner.check()
	
	thrust = 0
	if( btn_up   > 1 ):
		thrust =  0.3
		get_node("AnimationPlayer").play("fire")
	if( btn_down > 1 ):
		thrust = - 0.3
		get_node("AnimationPlayer").play("fire")
		
	if( btn_left  > 1 ):
		angular_velocity = angular_velocity + 0.01
	if( btn_right > 1 ):
		angular_velocity = angular_velocity - 0.01
		
	if( btn_fire  > 1 ):
		fire_timer += delta
		if (fire_timer > 0.2):
			fire_timer = 0
			new_bullet()
	elif (fire_timer < 0.2):
		fire_timer += delta
		
	if( btn_aftburn > 1 && afterburner > 0 ):
		afterburner -= 0.025
		thrust *= 3
	elif (afterburner < afterburner_max):
		afterburner += 0.005
	get_node("TextureProgress").set_value(afterburner*100)
		
func new_bullet():
	for i in range(2):
		var new_bullet = bullet.instance()
		new_bullet.set_pos( position  )
		new_bullet.set_rot( orientation )
		new_bullet.velocity = (direction + Vector2(rand_range(-0.05,0.05),rand_range(-0.05,0.05))) * 20
		get_node("../bullets").add_child( new_bullet )
	
func _draw():
#	self.draw_line( Vector2(0,0), asteroid , line_color1)
#	if ( dot > 0 ):
#		self.draw_line( Vector2(0,0), projection, Color(0,0,1))
#	else:
#		self.draw_line( Vector2(0,0), projection, Color(0.2,0.2,0.2))
#		
#	if ( cross > 0 ):
#		self.draw_line( asteroid, projection, Color(0,1,0),2)
#	else:
#		self.draw_line( asteroid, projection, Color(1,0,0),2)
	pass
	
func boom():
	get_node("Explosion/AnimationPlayer").play("boom")
		
func display_vectors():
	self.set_pos( position )
	get_node("Label_position").set_text( str(round(dot))+" "+str(round(cross)) )
	get_node("Sprite_ship").set_rot(orientation)

	self.update ( )
	pass

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	bullet = load("res://scenes/bullet.tscn")
	pass