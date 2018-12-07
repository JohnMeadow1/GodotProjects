extends Node2D

var points = PoolVector2Array()
var colors = PoolColorArray([Color(0.14, 0.0, 0.2, 1)])
var prev_point = Vector2()
var next_point = Vector2()
var value_0    = []
var value_1    = []
var value_2    = []
var blocks_history   = [[],[],[]]


var timer       = 3.5

func _ready():
	for i in range(4):
		points.push_back( Vector2() )

func _process(delta):
	if $"..".process == false && $"..".timer<0:
#	if timer < 0 && timer > -4:
#		value_0.push_back(rand_range($"..".blocks_population[0]-0.02,$"..".blocks_population[0]+0.02+sin(timer*3)*0.1 ) )
#		value_1.push_back(rand_range($"..".blocks_population[1]-0.02,$"..".blocks_population[1]+0.02+sin(timer*4)*0.1 ) )
#		value_2.push_back(rand_range($"..".blocks_population[2]-0.02,$"..".blocks_population[2]+0.02+sin(timer*5)*0.1 ) )
		update()
		
func _draw():
	var center = Vector2(50, 740)
	plot_values(center,0, Color(0.13,0.28,0.43,0.4))
	center.y += 75
	plot_values(center,1, Color(0.43,0.13,0.4,0.4))
	center.y += 75
	plot_values(center,2, Color(0.23,0.13,0.43,0.4))
	
func plot_values(center,value, color):
	var width = 202
	var height = 10
	var locla_color = colors
	locla_color[0].r -=0.05
	locla_color[0].b -=0.05
	for k in range(5):
#		prev_point =  center 
		color.a = color.a + 0.2
		locla_color[0].r +=0.01
		locla_color[0].b +=0.01
#		next_point =  Vector2(center.x, center.y + k*height)
		prev_point =  Vector2(center.x, center.y + k*height)
		for i in range( blocks_history[value].size() ):
			next_point =  Vector2(center.x + (i+1) * width, center.y + k*height )
			next_point += Vector2(0, -blocks_history[value][4-k][i]/35)
			points[0]  = center + Vector2( i * width,  k*height )
			points[1]  = prev_point
			points[2]  = next_point
			points[3]  = center + Vector2( ( i + 1  ) * width, k*height)
			draw_polygon( points, locla_color )
			draw_line( prev_point, next_point, color, 1 )
			prev_point = next_point
#func plot_values(center,value, color):
#	prev_point =  center 
#	next_point =  Vector2(center.x ,rand_range(0,100))
#
#	prev_point =  Vector2(center.x, center.y)
#	for i in range( value_0.size() ):
#		next_point =  Vector2(center.x + (i+1) * 15, center.y)
#		next_point += Vector2(0,-value[i]*100)
#		points[0]  = center + Vector2( i * 15,  0 )
#		points[1]  = prev_point
#		points[2]  = next_point
#		points[3]  = center + Vector2( ( i + 1  ) * 15, 0)
#		draw_polygon( points, colors )
#		draw_line( prev_point, next_point, color, 1 )
#		prev_point = next_point


	