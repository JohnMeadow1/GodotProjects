extends Node2D

var angle_to = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	angle_to += delta*100
	angle_to = get_parent().currnet_value / get_parent().max_value* 360
#	print(angle_to)
#	angle_to = fmod(angle_to,360)
	$Label.text = str("%04.1f" % (angle_to/3.6)+"%")
#	$Label.text = str(round(angle_to/0.36)/10 )+"%"
	update()
	pass

func draw_circle_arc_poly(center, radius, radius2, angle_from, angle_to, color):
	var nb_points  = 72
	var points_arc = PoolVector2Array()
	var prev_point =  center + Vector2(0,-1) * radius2
	points_arc.push_back( prev_point )
	var colors = PoolColorArray([color])
	
	for i in range( nb_points + 1 ):
		var angle_point = deg2rad(angle_from + i * ( angle_from - angle_to ) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	for i in range( nb_points, 0, -1 ):
		var angle_point = deg2rad(angle_from + i * ( angle_from - angle_to ) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius2)
		
	draw_polygon( points_arc, colors )
	points_arc.push_back( prev_point )
	draw_polyline( points_arc, Color( 0.7, 0.0, 1, 0.4 ),2, true )
	
func _draw():
	var center = Vector2(0, 0)
	var radius = 280
	var radius2 = 150
	var angle_from = 0
	var color = Color(0.24, 0.0, 0.40, 0.95)
	var color2 = Color(0.14, 0.0, 0.20, 1)
	draw_circle_arc_poly(center, radius, radius2, 0, 360, color2)
	draw_circle_arc_poly(center, radius, radius2, angle_from, angle_to, color)
