extends Node2D

### import the input helper class
var input_states = preload("input_states.gd")

### create input states classes
var state_up    = input_states.new("up")
var state_down  = input_states.new("down")
var state_left  = input_states.new("left")
var state_right = input_states.new("right")
var state_x     = input_states.new("tatatata")

var btn_up      = null
var btn_down    = null
var btn_left    = null
var btn_right   = null

var btn_x       = null

var line_color1         = Color( 1.0 ,0.0 ,0.0 )
var line_color2         = Color( 0.0 ,1.0 ,0.0 )

var position            = Vector2( 100, 100 )
var velocity            = Vector2( 0.0, 0.0 ) 


var rotation            = 0
var angular_velocity    = 0

var orientation         = Vector2 ( 0.0, 0.0 )
var thrust              = 0

var asteroid            = null
var asteroid_position   = Vector2 ( 0.0, 0.0 )
var asteroid_global_pos = Vector2 ( 0.0, 0.0 )

var projection          = Vector2 ( 0, 0 ) 
var mass = 200
var radius   = 30


func _fixed_process(delta):
	
	process_input()
	asteroid_global_pos = asteroid.get_pos()
	asteroid_position = asteroid_global_pos - position
		
	angular_velocity = angular_velocity * 0.95
	
	if ((asteroid_position - projection).length()<60 and orientation.dot(asteroid_position)>0):
		angular_velocity -= 0.01 * orientation.angle_to(asteroid_position)
	rotation = rotation + angular_velocity
	
	orientation = Vector2( cos(rotation), -sin(rotation) )
	projection = orientation.dot(asteroid_position)/orientation.length_squared() * orientation
	
	velocity = velocity + ( orientation * thrust )
	velocity = velocity * 0.97

	position = position + velocity
	
	display_vectors()

func process_input():

	btn_up    = state_up.check()
	btn_down  = state_down.check()
	btn_left  = state_left.check()
	btn_right = state_right.check()
	btn_x =     state_x.check()
	
	
	thrust = 0
	if( btn_up   > 1 ):
		thrust = 0.2
	if( btn_down > 1 ):
		thrust = -0.2
		
	if( btn_left  > 1 ):
		angular_velocity = angular_velocity + 0.005
	if( btn_right > 1 ):
		angular_velocity = angular_velocity - 0.005
		
	if ( btn_x > 1 ):
		thrust += -0.1
		get_parent().get_parent().generateBullet( position, orientation )
			
func _draw():
#	self.draw_line( Vector2(0,0), orientation * 100, line_color2)
#	self.draw_line( Vector2(0,0), asteroid_position, line_color2)
#	self.draw_line( Vector2(0,0), projection, Color(1,1,1))
#	
#	if ((asteroid_position- projection).length() <60):
#		self.draw_line( asteroid_position, projection, Color(1,0,0))
#	else:
#		self.draw_line( asteroid_position, projection, Color(1,1,0))
#
	pass
	
func display_vectors():
	self.set_pos( position )
	get_node("Sprite_ship").set_rot(rotation)

	self.update ( )
	pass

func _ready():
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	asteroid = get_node("../Asteroid")

	pass