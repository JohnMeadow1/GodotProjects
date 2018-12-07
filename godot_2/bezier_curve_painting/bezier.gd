extends Node2D



var control_points   = []
var control_velocity = []
var points           = []
var data             = null
var imageTexture     = null
var color            = Color(0,0,0)
var color_hsv        = Color(1,0,0)
var texture_blit_timer = 0
var steps            = 0 
var margin           = 50    # texture border margin for SHAPE_MODE = 1

#----------------------------# control variables 
var resolution       = Vector2( 1200, 800 ) # texture resolution
var COLOR_MODE       = 2     # (1 - 3) 
                             # 1 - red lines, 2 - hsv rainbow, 3 - white lines
var SHAPE_MODE       = 4     # (1 - 4) 
                             # 1 - lines, 2 - glyph, 3 - circles, 4 - kind of leftover function
var MOVE_MODE        = 1     # (1 - 2)
                             # 1 - velocity based, 2 - random based

var control_count    = 6     # (3 - x) control nodes count
var curves           = 2     # (1 - x) number of curves you wish to generate, this will split texture space
var steps_density    = 1     # (0.1 - x) density mutiplier of pixels between nodes

var direction_change = 0.05  # how stron node movement direction can change
var move_speed       = 0.5   # node movement speed
var color_step       = 0.004 # ( 0.004 - 0.04 ) how mucch color go to texture on put pixel call 
var verbose          = false # true - displays nodes, and their conections
#----------------------------- 

var rows             = int(curves / ceil(sqrt(curves)))
var collumns         = int(curves / rows)

func _ready():
	randomize()
	set_process(true)
	
	if (COLOR_MODE == 2): # for hsv rainbow color_step must have higher value to display all colors
		color_step *= 10
		
	imageTexture = ImageTexture.new()
	imageTexture.create( resolution.x, resolution.y, 3 ,0 )  
	get_node("Sprite").set_texture( imageTexture )
	data = Image( resolution.x, resolution.y, 0, 3 )

	for curve in range( curves ):
		control_points.append([])
		control_velocity.append([])
		var x_pos = 0
		var y_pos = 0
		var x_pos = floor(curve % collumns) * floor(resolution.x / collumns) + floor(resolution.x / (collumns * 2))
		var y_pos = ( curve / collumns )    * floor(resolution.y / rows)     + floor(resolution.y / (rows * 2))

		if ( SHAPE_MODE == 1 ):
			generate_line    ( curve )
		elif ( SHAPE_MODE == 2 ):
			generate_glyph   ( curve, resolution.y / curves , x_pos, y_pos )
		elif ( SHAPE_MODE == 3 ):
			generate_circles ( curve, resolution.y / curves , x_pos, y_pos )
		elif ( SHAPE_MODE == 4 ):
			generate_circles2( curve, resolution.y / curves , x_pos, y_pos )

	control_count = control_points[0].size()

func _process( delta ):

	texture_blit_timer += delta
	if ( texture_blit_timer > 0.03 ): # updates texture about 33 times/second 
		texture_blit_timer = 0
		imageTexture.set_data( data )
		update()
		
	for curve in range( curves ):
		draw_bezier_sand( curve )
		
	for curve in range( curves ):
		for i in range( control_count ):
			
			
			if (MOVE_MODE == 1):
				control_velocity[curve][i] += rand_range( -direction_change, direction_change )
				if (abs (control_velocity[curve][i]) > 1):
					control_velocity[curve][i] = - sign (control_velocity[curve][i]) - (-control_velocity[curve][i] + sign (control_velocity[curve][i])) 
				control_points  [curve][i] += Vector2( cos( control_velocity[ curve ][ i ] * PI ), -sin (control_velocity[ curve ][ i ] * PI ) ) * move_speed
				
			elif(MOVE_MODE == 2):
				control_points  [curve][i] += get_random_move(move_speed,move_speed)
	 
			if( control_points  [curve][i].y >= resolution.y ):
				control_points  [curve][i].y -= control_points   [curve][i].y - resolution.y
				control_velocity[curve][i]  = rand_range(-1,1)
			elif( control_points[curve][i].y  <= 0 ):
				control_points  [curve][i].y  = -control_points  [curve][i].y
				control_velocity[curve][i]  = rand_range(-1,1)
				
			if( control_points  [curve][i].x >= resolution.x ):
				control_points  [curve][i].x -= control_points   [curve][i].x - resolution.x
				control_velocity[curve][i]  = rand_range(-1,1)
			elif( control_points[curve][i].x  <= 0 ):
				control_points  [curve][i].x  = -control_points  [curve][i].x
				control_velocity[curve][i]  = rand_range(-1,1)

func generate_line( curve ):
	for i in range( control_count ):
		control_points[curve].push_back( Vector2( floor(i)     / (control_count-1) * (resolution.x - margin) + margin, \
			                                      floor(curve) / curves            * (resolution.y - margin) + margin ))
		control_velocity[curve].push_back( rand_range( -1, 1 ) )
		
func generate_glyph( curve, R, x_pos, y_pos ):
	for i in range( control_count ):
		control_points  [curve].push_back( get_point_in_circle( min ( R, resolution.y / 2 ) ) + Vector2( x_pos, y_pos ) )
		control_velocity[curve].push_back( rand_range( -1, 1 ) )
	
func generate_circles( curve, R, x_pos, y_pos  ):
	for i in range( control_count ):
		control_points[curve].push_back( Vector2( cos( float(i) / control_count * PI * 2 ) * min ( R, resolution.y / 2 ), \
			                                     -sin( float(i) / control_count * PI * 2 ) * min ( R, resolution.y / 2 ) )  + Vector2( x_pos, y_pos ) )
		control_velocity[curve].push_back( (float(i) / control_count) * 2 - 1 )
	control_points[curve].push_back( Vector2( cos( 2 * PI ) * min ( R, resolution.y / 2 ), \
			                                 -sin( 2 * PI ) * min ( R, resolution.y / 2 ) )  + Vector2( x_pos, y_pos ) )
	control_velocity[curve].push_back( 0.9999 )
	
func generate_circles2( curve, R, x_pos, y_pos ):
	for i in range( control_count ):
		control_points[curve].push_back( Vector2( cos( float(curve) / curves * PI * 2 ) * min ( R, resolution.y / 2 ) , \
			                                     -sin( float(curve) / curves * PI * 2 ) * min ( R, resolution.y / 2 )  ) + Vector2( x_pos, y_pos ) )
		control_velocity[curve].push_back( rand_range( -1, 1 ) )
		
func draw_bezier_sand( curve ):
	var A = Vector2()
	var B = Vector2()
	var C = Vector2()

	var vel_A = 0
	var vel_B = 0
	var vel_C = 0
	
	var point = Vector2()
	
	for i in range( control_count - 2 ):
		if  ( COLOR_MODE == 1 ):
			if ( i == 0 ):
				A     =  control_points  [ curve ][ i ]
			else:
				A     =  (control_points  [ curve ][ i ] + control_points[ curve ][ i + 1 ]) * 0.5
			if ( i == control_count-3 ):
				C     =  control_points  [ curve ][ i + 2 ]
			else:
				C     =  (control_points  [ curve ][ i + 1 ] + control_points[ curve ][ i + 2 ]) * 0.5
			B     =  control_points  [ curve ][ i + 1 ]
			steps = int( ( (B-A).length() + (C-B).length() ) * steps_density )
			for step in range( steps ):
				var t = float(step)/steps
				point = get_bezier_quadric( t, A, B, C )
				if (point.x < resolution.x && point.x > 0 && point.y < resolution.y && point.y > 0):
					color = data.get_pixel( point.x, point.y, 0 )
					color = slide_RGB( color )
					data.put_pixel( point.x, point.y, color, 0 )
		elif( COLOR_MODE == 2 ):
			if ( i == 0 ):
				A     =  control_points  [ curve ][ i ]
				vel_A = (control_velocity[ curve ][ i ] + 1.0 ) / 2
			else:
				A     =  (control_points  [ curve ][ i ] + control_points[ curve ][ i + 1 ]) * 0.5
				vel_A = ((control_velocity[ curve ][ i ] + 1.0 ) / 2 + (control_velocity[ curve ][ i + 1 ] + 1.0 ) / 2 ) * 0.5
			if ( i == control_count-3 ):
				C     =  control_points  [ curve ][ i + 2 ]
				vel_C = (control_velocity[ curve ][ i + 2 ] + 1.0 ) / 2
			else:
				C     =  (control_points  [ curve ][ i + 1 ] + control_points[ curve ][ i + 2 ]) * 0.5
				vel_C = ((control_velocity[ curve ][ i + 1 ] + 1.0 ) / 2 + (control_velocity[ curve ][ i + 2 ] + 1.0 ) / 2 ) * 0.5
			B     =  control_points  [ curve ][ i + 1 ]
			vel_B = (control_velocity[ curve ][ i + 1 ] + 1.0 )/2
			steps = int( ( (B-A).length() + (C-B).length() ) * steps_density )
			for step in range( steps ):
				var t = float(step)/steps
				point = get_bezier_quadric( t, A, B, C )
				if (point.x < resolution.x && point.x > 0 && point.y < resolution.y && point.y > 0):
					color = data.get_pixel( point.x, point.y, 0 )
					color_hsv.h = (get_bezier_quadric( t, vel_A, vel_B, vel_C ))
					color = blend_HSV( color )
					data.put_pixel( point.x, point.y, color, 0 )
		elif( COLOR_MODE == 3 ):
			if ( i == 0 ):
				A     =  control_points  [ curve ][ i ]
			else:
				A     =  (control_points [ curve ][ i ] + control_points[ curve ][ i + 1 ]) * 0.5
			if ( i == control_count-3 ):
				C     =  control_points  [ curve ][ i + 2 ]
			else:
				C     =  (control_points [ curve ][ i + 1 ] + control_points[ curve ][ i + 2 ]) * 0.5
			B     =  control_points  [ curve ][ i + 1 ]
			steps = int( ( (B-A).length() + (C-B).length() ) * steps_density )
			for step in range( steps ):
				var t = float(step)/steps
				point = get_bezier_quadric( t, A, B, C )
				if (point.x < resolution.x && point.x > 0 && point.y < resolution.y && point.y > 0):
					color = data.get_pixel( point.x, point.y, 0 )
					color = paint_to_black( color )
					data.put_pixel( point.x, point.y, color, 0 )
			
		for step in range( steps ):
			var t = float(step)/steps
			point = get_bezier_quadric( t, A, B, C )
			if (point.x < resolution.x && point.x > 0 && point.y < resolution.y && point.y > 0):
				color = data.get_pixel( point.x, point.y, 0 )

func get_point_in_sphere( R ):
	var phi      = rand_range( 0, 2 * PI )
	var costheta = rand_range(-1, 1 )
	var u        = rand_range( 0, 1 )
	var theta    = acos( costheta )
	var r        = R * pow( u,0.3333333 )
	return Vector3( r * sin( theta) * cos( phi ), r * sin( theta) * sin( phi ), r * cos( theta ))

func get_point_in_circle( R ):
	var phi      = rand_range( 0, 2 * PI )
	var u        = rand_range( 0, 1 )
	var r        = R * sqrt( u )
	return Vector2( r * cos( phi ) , r * -sin( phi ) )
	
func get_random_move( magnitude_x, magnitude_y ):
	return Vector2( rand_range( - magnitude_x, magnitude_x ),rand_range( - magnitude_y, magnitude_y ) )

func paint_to_black (color):
	if ( (color.r + color_step) <= 1):
		color.r = color.r + color_step
		color.g = color.g + color_step
		color.b = color.b + color_step
	else:
		color = Color( 0, 0, 0 )
	return color
	
func blend_HSV( color ):
	if (color_hsv.r > color.r):
		color.r = min (color.r + color_hsv.r * color_step, 1)
	else:
		color.r = max (color.r - color_hsv.r * color_step, 0)
	if (color_hsv.g > color.g):
		color.g = min (color.g + color_hsv.g * color_step, 1)
	else:
		color.g = max (color.g - color_hsv.g * color_step, 0)
	if (color_hsv.b > color.b):
		color.b = min (color.b + color_hsv.b * color_step, 1)
	else:
		color.b = max (color.b - color_hsv.b * color_step, 0)
	return color

func slide_RGB( color ):
	if ( color.r < 1 && color.g <= 0 && color.b <=0 ):
		color.r = min ( color.r + color_step, 1 )
	elif ( color.r >= 1 && color.g < 1 && color.b <=0 ):
		color.g = min ( color.g + color_step, 1 )
	elif( color.r >= 1 && color.g >= 1 && color.b < 1):
		color.b = min ( color.b + color_step, 1 )
	elif(color.g >= 1 && color.b >= 1 && color.r > 0):
		color.r = max ( color.r - color_step, 0 )
	elif(color.r <= 0 && color.b >= 1 && color.g > 0):
		color.g = max ( color.g - color_step, 0 )
	elif(color.r <= 0 && color.g <= 0 && color.b > 0):
		color.b = max ( color.b - color_step, 0 )
	return color
	
func get_bezier_quadric( t, A, B, C ):
	var a = 1 - t
	return A * pow(a,2) + 2 * B * a * t +  C * pow(t,2)
	
func get_bezier_cubic( t, A, B, C, D ):
	var a = 1 - t
	return A * pow(a,3) + 3 * B * pow(a,2) * t + 3 * C * a * pow(t,2) + D * pow(t,3) 
	
func _draw():
	if (verbose):
		for curve in range( curves ):
			for i in range( control_count - 1 ):
				draw_circle( control_points[curve][i], 2, Color( 0.5, 0.5, 0.5, 0.5 ) )
				draw_line( control_points[curve][i], control_points[curve][i + 1], Color( 0.5, 0.5, 0.5, 0.1) , 1 )
			draw_circle( control_points[curve][control_count - 1], 2, Color( 0.5, 0.5, 0.5, 0.3) )