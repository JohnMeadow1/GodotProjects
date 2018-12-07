extends Node2D

var BLOCK_COLORS = [Color(1,0,0),Color(1,1,0),Color(1,0,1) ]
var FONT_COLORS  = [Color(1,1,1),Color(1,1,1),Color(1,1,1) ]

var size        = Vector2()
var block_color = Color()
var font_color  = Color()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func set_group( new_group ):
	block_color  = BLOCK_COLORS[ new_group ]
	font_color   = FONT_COLORS[  new_group ]
	$Label.add_color_override( "font_color", Color(0,0,0) )
	
	update()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	draw_rect( Rect2(Vector2(), Vector2(size.x,size.y)), Color(1,1,1), true) 
	draw_line( Vector2(), Vector2(size.x,0), block_color )
	draw_line( Vector2(), Vector2(0,size.y), block_color )
	draw_line( Vector2(size.x,size.y), Vector2(size.x,0), Color(1,1,1) )
#	draw_line( Vector2(size.x,size.y), Vector2(0,size.y), block_color )