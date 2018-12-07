#tool
extends Node

var field = []
var FIELD_RESOLUTION   = 64
var circle_resolution  = 60
var influenece_range   = 0.03
var move_vector_array  = []
var confidence_array   = []
var array_length       = 60
var vector_array_index = 0

var new_pos  = Vector3()
var prev_pos = Vector3(1,0,0)
var theta    = 0

func _ready():
	set_fixed_process(true)
	initiate_field()
	test_circle()
	generate_field()
	get_node("Enviroment/floor").set_translation( Vector3( 0, -FIELD_RESOLUTION / 2, 0 ) )

func _fixed_process(delta):
#	test_object_move()
	move_test_object()
	pass

func test_object_move():  
	var test_cube = get_node("TestCube").get_translation() + Vector3( FIELD_RESOLUTION / 2, FIELD_RESOLUTION / 2, FIELD_RESOLUTION / 2)
	if test_cube.x < FIELD_RESOLUTION && test_cube.x > 0:
		if test_cube.y < FIELD_RESOLUTION && test_cube.y > 0:
			if test_cube.z < FIELD_RESOLUTION && test_cube.z > 0:
				get_node("TestCube").set_translation( get_node("TestCube").get_translation() + prev_pos )
				move_vector_array.append( get_node("TestCube").get_translation() )
				new_pos = field[ int(test_cube.x) ][ int(test_cube.y) ][ int(test_cube.z) ]
				if new_pos.length() > 0.1:
					prev_pos = new_pos
				draw()

func move_test_object():
#	var circle_offset = Vector3( 10.0, 10.0, 0 )
	var error = Vector3(0.03,0.01,0.06)
	theta += rand_range(1,3)
	theta = fmod( theta, 360)
	var angle = deg2rad( theta )
	new_pos = ((Vector3( cos( angle ), -sin( angle ), 0 ) ) / 2)
	new_pos += Vector3( rand_range(-0.01, 0.01), rand_range(-0.01, 0.01), rand_range(-0.01, 0.01) )
	new_pos += error
	new_pos *= ( FIELD_RESOLUTION - 5 )
	new_pos *= Vector3( 0.95, 0.8, 1 )
	get_node("TestCube").set_translation( new_pos )
#	print(new_pos+Vector3(FIELD_RESOLUTION/2, FIELD_RESOLUTION/2, FIELD_RESOLUTION/2) )
	var confidence = 0
	if new_pos.x + FIELD_RESOLUTION/2 >=0 && new_pos.x + FIELD_RESOLUTION/2 < FIELD_RESOLUTION:
		if new_pos.y + FIELD_RESOLUTION/2 >=0 && new_pos.y + FIELD_RESOLUTION/2 < FIELD_RESOLUTION:
			if new_pos.z + FIELD_RESOLUTION/2 >=0 && new_pos.z + FIELD_RESOLUTION/2 < FIELD_RESOLUTION:
#				print(new_pos)
				var vector_field_coordinates = Vector3(int(new_pos.x + FIELD_RESOLUTION/2), int(new_pos.y + FIELD_RESOLUTION/2), int(new_pos.z + FIELD_RESOLUTION/2) )
				var found_vector = field[vector_field_coordinates.x][vector_field_coordinates.y][vector_field_coordinates.z]
				confidence = found_vector.normalized().dot((new_pos-prev_pos).normalized()) 
				
#	print(confidence)
	prev_pos = new_pos
	if  move_vector_array.size()<array_length:
		move_vector_array.append( new_pos )
		confidence_array.append( confidence )
	else:
		move_vector_array[vector_array_index] = new_pos
		confidence_array[vector_array_index]  = confidence
	vector_array_index += 1
	vector_array_index %= array_length
	calculate_confidence()
#	print(new_pos)
#	get_node("TestCube").set_translation( ( + circle_offset)/2)*(FIELD_RESOLUTION-1)/FIELD_RESOLUTION

func initiate_field():
	for x in range (FIELD_RESOLUTION):
		field.append([])
		for y in range (FIELD_RESOLUTION):
			field[x].append([])
			for z in range (FIELD_RESOLUTION):
				field[x][y].append( Vector3(0,0,0) )
	
func test_circle():
	var circle_points = []
	var circle_offset = Vector2( 1.0, 1.0 )
#	for theta in range (36):
#		var angle = deg2rad(theta)
#		print(Vector2(cos(angle), -sin(angle)))
	
	for theta in range (circle_resolution):
		var angle = deg2rad(float(theta)/circle_resolution*360)
		circle_points.append( ((Vector2( cos( angle ), -sin( angle ) ) + circle_offset)/2)*(FIELD_RESOLUTION-1)/FIELD_RESOLUTION )
		

	var time_start = OS.get_unix_time()
	build_test_field_2(circle_points)
	var elapsed = OS.get_unix_time() - time_start
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	print("elapsed : ", str_elapsed,"sec")

func build_test_field_2(circle_points):
	var field_cordinates = Vector3()
#	field_cordinates = Vector3(x,y,z)/float(FIELD_RESOLUTION)
	var distance          = 0
	var shortest_distance = 0
	for i in range( circle_points.size() ):
		print("Building test field: " + str(round(float(i+1)/ circle_points.size() *100)) + "%")
#		var gesture_coords = Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0) * FIELD_RESOLUTION
		var gesture_coords_x = int((circle_points[(i+1)%circle_resolution].x ) * FIELD_RESOLUTION) 
		var gesture_coords_y = int((circle_points[(i+1)%circle_resolution].y ) * FIELD_RESOLUTION) 
		var gesture_coords_z = int(0.5 * FIELD_RESOLUTION) 
#		field_cordinates
		for x in range (clamp(gesture_coords_x - 10, 0,FIELD_RESOLUTION), clamp(gesture_coords_x + 10, 0,FIELD_RESOLUTION ) ):
			for y in range (clamp(gesture_coords_y - 10, 0,FIELD_RESOLUTION), clamp(gesture_coords_y + 10, 0,FIELD_RESOLUTION ) ):
				for z in range (clamp(gesture_coords_z - 10, 0,FIELD_RESOLUTION), clamp(gesture_coords_z + 10, 0,FIELD_RESOLUTION ) ):
#					print(x,' ',y,' ',z,' ')
					if (Vector3( x, y, z ) - Vector3(gesture_coords_x,gesture_coords_y,gesture_coords_z)).length_squared() <= 100:
						distance       = 1 #- ((Vector3( x, y, z ) - Vector3(gesture_coords_x,gesture_coords_y,gesture_coords_z)).length_squared() / 300)
						field[x][y][z] += Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0) * 2 * distance
#					print(Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0))
#			if  distance < influenece_range:field[x][y][z] += Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0) * ((influenece_range - distance) / influenece_range)*4
#						if distance < shortest_distance:
#							shortest_distance = distance
#				field[x][y][z] += Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0) * ((influenece_range - distance) / influenece_range)*4
#				field[x][y][z] = field[x][y][z].normalized() * ((influenece_range - shortest_distance) / influenece_range)
#				print(((influenece_range - shortest_distance) / influenece_range))


func build_test_field_1(circle_points):
	var field_cordinates = Vector3()
	for x in range (FIELD_RESOLUTION):
		print("Building test field: " + str(round(float(x+1)/FIELD_RESOLUTION *100)) + "%")
		for y in range (FIELD_RESOLUTION):
			for z in range (FIELD_RESOLUTION):
				field_cordinates = Vector3(x,y,z)/float(FIELD_RESOLUTION)
				var distance          = 0
				var shortest_distance = 0
				for i in range( circle_points.size() ):
					distance = ( Vector3( circle_points[i].x, circle_points[i].y, 0.5 ) - field_cordinates).length_squared()
					if  distance < influenece_range:
#						if distance < shortest_distance:
#							shortest_distance = distance
						field[x][y][z] += Vector3( circle_points[(i+1)%circle_resolution].x - circle_points[i].x, circle_points[(i+1)%circle_resolution].y - circle_points[i].y, 0) * ((influenece_range - distance) / influenece_range)*4
#				field[x][y][z] = field[x][y][z].normalized() * ((influenece_range - shortest_distance) / influenece_range)
#				print(((influenece_range - shortest_distance) / influenece_range))

func generate_field( ):
	var space_offset      = Vector3(1,1,1) * (FIELD_RESOLUTION*0.5)
	var field_geo         = get_node("Vector_field")
	var vector_start_geo  = get_node("Vector_starting_point")
	field_geo.begin(        VS.PRIMITIVE_LINES, null )
	vector_start_geo.begin( VS.PRIMITIVE_POINTS, null )
	
	var vector_color = Color(1,1,1)
	for x in range (FIELD_RESOLUTION):
		print("Generating field: " + str(round(float(x+1)/FIELD_RESOLUTION *100)) + "%")
		for y in range (FIELD_RESOLUTION):
			for z in range (FIELD_RESOLUTION):
				if field[x][y][z].length_squared() > 0.05:
					vector_start_geo.add_vertex( Vector3( x, y, z ) - space_offset )

					vector_color = Color( (field[x][y][z].x+1)/2, ( field[x][y][z].y+1)/2, (field[x][y][z].z+1)/2 )
					vector_color.a = min(1, field[x][y][z].length())
					field_geo.set_color( vector_color )
					field_geo.add_vertex( Vector3(x,y,z) - space_offset )
					field_geo.add_vertex( Vector3(x,y,z) - space_offset + field[x][y][z] )
	field_geo.end()
	vector_start_geo.end()

func calculate_confidence():
	var total_confidence = 0
	var ray_geo = get_node("Ray_geometry")
	ray_geo.clear()
	ray_geo.begin( VS.PRIMITIVE_LINE_STRIP, null )
	for i in range(move_vector_array.size()):
		total_confidence += confidence_array[i]
		ray_geo.add_vertex( move_vector_array[i] )
	ray_geo.end()
	total_confidence /= array_length
	get_node("CanvasLayer/Label").set_text(str(total_confidence))
	
func draw():
	var ray_geo = get_node("Ray_geometry")
	ray_geo.clear()
	ray_geo.begin( VS.PRIMITIVE_LINE_STRIP, null )
	for i in range(move_vector_array.size()):
		ray_geo.add_vertex( move_vector_array[i] )
	ray_geo.end()