extends Node2D
var pixel_scale = 1
var width       = 320.0
var height      = 48.0
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
			formula(x,y)
			data.set_pixel( x, y, Color(red,green,blue) )
	data.unlock()
	imageTexture.set_data(data)

func _input(event):
	if event.is_action_pressed("Down")  : get_tree().change_scene_to(load("res://slides/wave.tscn"))


func formula( x, y ):
#cool looking sine wave 
	var f1 = 14.0*sin((x+time*12)/24.0)
	var f2 = 14.0*sin((x+time*12)/24.0)
	
	var gain = 0.6+abs(clamp(tan(x/130.0-time),-5,5))
	
	red   = -abs(y-(height/2)-sin(f1/6.00)*12) +gain
	blue  = -abs(y-(height/2)-tan(f1/12.0)*7.5)+gain
	green = -abs(y-(height/2)-f2)              +gain+red/4