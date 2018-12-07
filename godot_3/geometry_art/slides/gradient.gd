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
#	data.lock()
#	var color = Color(1,1,1)
#	for i in range(resolution.y):
#		for j in range(resolution.x):
#			data.put_pixel( j, i, color, 0 )
#	data.unlock()

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
	if event.is_action_pressed("Next") && function_id<3:
		function_id += 1
		time = 0
	if event.is_action_pressed("Prev") && function_id>1:
		function_id -= 1
		time = 0
	if event.is_action_pressed("debug") : toggle_debug()
	if event.is_action_pressed("Up") : get_tree().change_scene_to(load("res://slides/parabole.tscn"))
	if event.is_action_pressed("Down") : get_tree().change_scene_to(load("res://main.tscn"))

	$CanvasLayer/DebugLabel.text = str(function_id)
func toggle_debug():
	$CanvasLayer/DebugLabel.visible = !$CanvasLayer/DebugLabel.visible
	$CanvasLayer/formula.visible = !$CanvasLayer/formula.visible

func formula_1( x, y ):
	$CanvasLayer/formula.text = "formula:\nred x / width\nblue = (width - x) / width"

	#simple gradient
	red = x / width
	blue = (width - x) / width
	
func formula_2( x, y ):
	$CanvasLayer/formula.text = "formula:\nred x / width\nblue = (width - x) / width\ngreen = (time * x) % height / height"

	#simple gradient
	red   = x / width
	blue  = (width - x) / width
	green = float(int(time*x)%int(height))/height
	
func formula_3( x, y ):
#	$CanvasLayer/formula.text = "formula:\nred x / width\nblue = (width - x) / width\ngreen = (time * x) % height / height"
	red   = float( int(sin(x*time)*100) ^ int(cos(y*time)*100)) / 8.0
#	print(red)
	blue  = 1-red
#	blue  = float((int(width)-x)^(int(height)-y)) / 128.0
	green = float( int(cos(x*time)*100) ^ int(sin(y*time)*100)) / 8.0
#	green = float(x^y) / 128.0
#	blue  = (width - x) / width
#	green = float(int(time*x)%int(height))/height
