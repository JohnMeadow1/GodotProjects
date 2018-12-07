
extends Node2D

var ship                = null
var ship_position       = Vector2 ( 0.0, 0.0 )

var asteroid            = null
var asteroid_position   = Vector2 ( 0.0, 0.0 )
var vectorField         = Vector2Array()

var drone               = null
var drone_position      = Vector2 ( 0.0, 0.0 )

func _fixed_process(delta):
	asteroid_position = asteroid.get_pos()
	ship_position     = ship.get_pos()
	drone_position    = drone.get_pos()
#	print (drone_position)
	drone_position = drone_position + calculate_vector( drone_position )
	drone.set_pos(drone_position)
	
	update()
	pass
func calculate_vector( cell_position ):
	var cell_vector = Vector2()
	var distance_to_object = 0.0
	var vector_to_object = cell_position - ship_position
	distance_to_object = vector_to_object.length_squared()
	cell_vector += vector_to_object.normalized() * 100000 / distance_to_object
	
	vector_to_object = cell_position - asteroid_position
	distance_to_object = vector_to_object.length_squared()
	cell_vector += vector_to_object.normalized() * 100000 / distance_to_object

#	vector_to_object = cell_position - drone_position
#	distance_to_object = vector_to_object.length_squared()
#	cell_vector += vector_to_object.normalized() * 100000 / distance_to_object
#		
	return cell_vector.normalized() * min(cell_vector.length(), 18)
	pass
	
func _draw():

	for i in range(1200):
		var x = i % 40	
		var y = floor(i/40)
		vectorField[i] = calculate_vector (Vector2(x*20,y*20))
		draw_line( Vector2(x*20,y*20), Vector2(x*20,y*20) + vectorField[i], Color(1,1,1))
		pass
	pass
	pass
	
func _ready():
	# Initialization here
	set_fixed_process(true)
	asteroid = get_node("Asteroid")
	ship     = get_node("Spaceship")
	drone    = get_node("Drone")
	vectorField.resize(1200)
	pass

