extends Node2D

var pixel_scale = 1
var width       = 640.0
var height      = 640.0
var angle_to    = 0

func _ready():
	OS.set_window_size( Vector2 ( width * pixel_scale, height * pixel_scale ) )


func _process(delta):
	angle_to += delta * 100
	angle_to = fmod(angle_to,12960)
#	print(angle_to)
	$Label5.text = str("%04.1f" % (angle_to/3.6)+"%")
	update()
	
func _input(event):
	if event.is_action_pressed("Up") : get_tree().change_scene_to(load("res://slides/gradient.tscn"))

func draw_circle_arc_poly(center, radius, radius2, angle_from, angle_to, color):
	var nb_points  = 36
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
		
#	draw_polygon( points_arc, colors )
	points_arc.push_back( prev_point )
	draw_polyline( points_arc, Color( 0.7, 0.0, 1, 0.4 ),2, true )
	
func _draw():
	var center = Vector2(320, 300)
	var radius = 150
	var radius2 = 100
	var angle_from = 0
	var color = Color(0.7, 0.0, 1, 0.4)
	draw_circle_arc_poly(center, radius, radius2, angle_from, angle_to, color)
	

