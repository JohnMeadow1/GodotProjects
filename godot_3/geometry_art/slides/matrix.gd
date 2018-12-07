extends Node2D

var pixel_scale = 1
var width       = 128.0
var height      = 128.0
var time        = 0
var red         = 0 
var green       = 0 
var blue        = 0
var function_id = 1

var data             = null
var imageTexture     = null


func _ready():
#	OS.set_window_size( Vector2 ( width * pixel_scale, height * pixel_scale ) )
	initialize_image()

func initialize_image():
	data = Image.new()
	data.create(width, height, false, Image.FORMAT_RGB8)

	imageTexture = ImageTexture.new()
	imageTexture.create_from_image( data ,0 )  
	get_node("Sprite").set_texture( imageTexture )

func _process(delta):
	time += delta
	data.lock()
	for x in range(width):
		for y in range(height):
			call('formula_'+str(function_id),x,y)
			data.set_pixel( x, y, Color(red,green,blue) )
	data.unlock()
	imageTexture.set_data(data)
	
func _input(event):
	if event.is_action_pressed("Next") && function_id<9: 
		function_id += 1
		time = 0
	if event.is_action_pressed("Prev") && function_id>1: 
		function_id -= 1
		time = 0
	if event.is_action_pressed("debug") : toggle_debug()
	if event.is_action_pressed("Up") : get_tree().change_scene_to(load("res://slides/wave.tscn"))
	if event.is_action_pressed("Down") : get_tree().change_scene_to(load("res://slides/parabole.tscn"))
	
	$CanvasLayer/DebugLabel.text = str(function_id)
func toggle_debug():
	$CanvasLayer/DebugLabel.visible = !$CanvasLayer/DebugLabel.visible
	$CanvasLayer/formula.visible = !$CanvasLayer/formula.visible
	
func formula_1( x, y ):
	#matrix effect
#	g = 0.72 * rand_range(0.2,0.3*tan((y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w))+b
	$CanvasLayer/formula.text = "formula:\nc = 1\ny - c\nc / width"
	green = 1
#	green = green % ( x + 1)
	green = y - green 
#	green = green - (time * 18.0)
	green = green / width
#	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
	
func formula_2( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = x\ny - c\nc / width"
	green = x
#	green = green % ( x + 1)
	green = y - green 
#	green = green - (time * 18.0)
	green = green / width
#	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
	
func formula_3( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = x\ny - c\nc - (time * 18.0)\nc / width"

	green = x
#	green = green % ( x + 1)
	green = y - green 
	green = green - (time * 18.0)
	green = green / width
#	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
	
func formula_4( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -10\nc % ( x + 1)\ny - c\nc - (time * 18.0)\nc / width"

	green = -10
	green = green % ( x + 1)
	green = y - green 
	green = green - (time * 18.0)
	green = green / width
#	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	
	blue = 0.38 * green
	red = green-blue

func formula_5( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -1000\nc % ( 10 * x + 1)\ny - c\nc - (time * 18.0)\nc / width"

	green = -1000
	green = green % ( 10 * x + 1)
	green = y - green 
	green = green - (time * 18.0)
	green = green / width
#	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue

func formula_6( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -1000\nc % ( 10 * x + 1)\ny - c\nc - (time * 18.0)\nc / width\ntan( c )"

	green = -1000
	green = green % ( 10 * x + 1)
	green = y - green 
	green = green - (time * 18.0)
	green = green / width
	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue

func formula_7( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -2147483648\nc % ( 10 * x + 1)\ny - c\nc - (time * 18.0)\nc / width\ntan( c )"

	green = (-2147483648)
	green = green % (10 * x + 1)
	green = y - green - (time * 18.0)
	green = green / width
	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
	
func formula_8( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -2147483648\nc % ( 40 * x + 1)\ny - c\nc - (time * 18.0)\nc / width\ntan( c )"

	green = (-2147483648)
	green = green % (40 * x + 1)
	green = y - green - (time * 18.0)
	green = green / width
	green = tan( green )
#	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
	
func formula_9( x, y ):
	$CanvasLayer/formula.text = "formula:\nc = -2147483648\nc % ( 40 * x + 1)\ny - c\nc - (time * 18.0)\nc / width\ntan( c )\n0.72 * rand_range(0.2,0.3 * c )"

	green = (-2147483648)
	green = green % (40 * x + 1)
	green = y - green - (time * 18.0)
	green = green / width
	green = tan( green )
	green = 0.72 * rand_range(0.2,0.3 * green )
	
	blue = 0.38 * green
	red = green-blue
