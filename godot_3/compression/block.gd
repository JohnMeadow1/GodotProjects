extends Node2D

var id_group = 0

var BLOCK_COLORS = [Color(0.13,0.28,0.43),Color(0.43,0.13,0.4),Color(0.23,0.13,0.43) ]
var FONT_COLORS  = [Color(1,1,1),Color(1,1,1),Color(1,1,1) ]

var block_color = Color()
var font_color  = Color()

var group_size  = 0
var size        = Vector2()
var target_size = Vector2()
var change_rate = 0
var double      = false

func _ready():
	randomize()
	set_group( int(randi() % 3 + randi() % 3)/2 )

func _process(delta):
	if size.x > target_size.x:
		size.x -= change_rate
		if size.x<target_size.x:
			size.x = target_size.x
		update()

func set_group( new_group ):
	id_group     = new_group
	block_color  = BLOCK_COLORS[ id_group ]
	font_color   = FONT_COLORS[  id_group ]
	change_rate  = float(size.x-target_size.x )/160
#	change_rate  = 0
#	$Label.text  = str( id_group )
#	$Label.add_color_override( "font_color", font_color )
#	$Label.add_color_override( "font_color_shadow", Color(0,0,0) )
	update()
	
func _draw():
	if double:
		draw_rect( Rect2(Vector2(-2,0), Vector2(size.x,size.y)), block_color, true) 
		draw_line( Vector2(-2,0), Vector2(size.x,0), Color(0.7, 0.0, 1, 0.4) )
#		draw_line( Vector2(), Vector2(0,size.y), Color(1,1,1) )
		draw_line( Vector2(size.x,size.y), Vector2(size.x,0), Color(0.7, 0.0, 1, 0.4) )
		draw_line( Vector2(size.x,size.y), Vector2(-2,size.y), Color(0.7, 0.0, 1, 0.4) )
	else:
		draw_rect( Rect2(Vector2(), Vector2(size.x,size.y)), block_color, true) 
		draw_rect( Rect2(Vector2(), Vector2(size.x,size.y)), Color(0.7, 0.0, 1, 0.4), false) 