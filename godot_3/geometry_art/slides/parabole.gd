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

var glith       = false
var pixel_color = Color(1,1,1)


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
			if glith:
				pixel_color = data.get_pixel( x, y )
				pixel_color.r = pixel_color.r*0.95 + max(red,0) * 0.2
				pixel_color.g = pixel_color.g*0.95 + max(green,0) * 0.2
				pixel_color.b = pixel_color.b*0.95 + max(blue,0) * 0.2
				
				data.set_pixel( x, y, pixel_color )
			else:
				data.set_pixel( x, y, Color(red,green,blue) )
	data.unlock()
	imageTexture.set_data(data)

func _input(event):
	if event.is_action_pressed("Next") && function_id<23:
		function_id += 1
		time = 0
	if event.is_action_pressed("Prev") && function_id>1:
		function_id -= 1
		time = 0
	if event.is_action_pressed("glith") : glith()
	if event.is_action_pressed("debug") : toggle_debug()
	if event.is_action_pressed("Up")    : get_tree().change_scene_to(load("res://slides/matrix.tscn"))
	if event.is_action_pressed("Down")  : get_tree().change_scene_to(load("res://slides/gradient.tscn"))

	$CanvasLayer/DebugLabel.text = str(function_id)
	
func toggle_debug():
	$CanvasLayer/DebugLabel.visible = !$CanvasLayer/DebugLabel.visible
	$CanvasLayer/formula.visible    = !$CanvasLayer/formula.visible

func glith():
	glith = !glith
	data.lock()
	var color = Color(0,0,0)
	for x in range(width):
		for y in range(height):
			data.set_pixel( x, y, color )
	data.unlock()

func formula_1( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( x / 6.0) \n"

	var f1 = sin( x / 6.0)
	var f2 = cos( x / 24.0)
	red   = f1
#	red   = -abs( y - ( height / 2 ) + f1 ) + 1.2
#	green = -abs( y - ( height / 2 ) + f2) + 1.2
	green = red
	blue  = red #/ 4 + cos( x * 2 / width + time) * 0.8
	
func formula_2( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( x / 6.0 ) / 2.0 + 0.5 \n"

	var f1 = sin( x / 6.0 ) / 2.0 + 0.5
	var f2 = cos( x / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = red
	blue  = red 
	
func formula_3( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( x / 6.0 ) / 2.0 + 0.5 \nf2 = cos( x / 6.0 ) / 2.0 + 0.5"

	var f1 = sin( x / 6.0 ) / 2.0 + 0.5
	var f2 = cos( x / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = red
	blue  = f2
	
func formula_4( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( x / 6.0 ) / 2.0 + 0.5 \nf2 = cos( x / 6.0 ) / 2.0 + 0.5"

	var f1 = sin( x / 6.0 ) / 2.0 + 0.5
	var f2 = cos( x / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = 1-f1
	blue  = f2
	
func formula_5( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5"

	var f1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5
	var f2 = cos( x / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = red
	blue  = red
	
func formula_6( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5\nsin( (time * 5 - x) / 6.0 ) / 2.0 + 0.5"

	var f1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5
	var f2 = sin( (time * 5 - x) / 6.0 ) / 2.0 + 0.5
#	var f2 = cos( x / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = f2
	blue  = red
	
func formula_7( x, y ):
# sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5\nsin( (time * 15 - x) / 6.0 ) / 2.0 + 0.5"

	var f1 = sin( (time * 5 + x) / 6.0 ) / 2.0 + 0.5
	var f2 = sin( (time * 15 - x) / 6.0 ) / 2.0 + 0.5
	var f3 = cos( (time * 7 + x)  / 6.0 ) / 2.0 + 0.5
	red   = f1
	green = f2
	blue  = f3
	
func formula_8( x, y ):
#rainbow sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 20.0 ) * 20 \ncolor = -abs( y - ( height / 2 ) + f1 ) + 1.2"
#	var f1 = 14.0 * sin( ( x + time * 12 ) / 24.0)
	var f1 = sin( (time * 5 + x) / 20.0 ) * 20
	red   = -abs( y - ( height / 2 ) + f1 ) + 1.2
	green = red
	blue  = red


func formula_9( x, y ):
#rainbow sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 10.0 ) * 20\nf2 = cos( (time * 17 + x) / 6.0 ) * 20\ncolor = -abs( y - ( height / 2 ) + f1 + f2 ) + 1.2"
	var f1 = sin( (time * 5 + x) / 10.0 ) * 20
	var f2 = cos( (time * 17 + x) / 6.0 ) * 20
	red   = -abs( y - ( height / 2 ) + f1+f2 ) + 1.2
	green = red
	blue  = red

func formula_10( x, y ):
#rainbow sine wave
	$CanvasLayer/formula.text = "formula:\nf1 = sin( (time * 5 + x) / 10.0 ) * 20\nf2 = cos( (time * 17 + x) / 6.0 ) * 20\nred   = -abs( y - ( height / 2 ) + f1+f2 ) + 4.2\n	green = red / 2 + sin( x * 2 / width + time) * 0.8\n	blue  = red / 6 + cos( x * 2 / width + time) * 0.8"
	var f1 = sin( (time * 5 + x) / 10.0 ) * 20
	var f2 = cos( (time * 17 + x) / 6.0 ) * 20
	red   = -abs( y - ( height / 2 ) + f1+f2 ) + 4.2
	green = red / 2 + sin( x * 2 / width + time) * 0.8
	blue  = red / 6 + cos( x * 2 / width + time) * 0.8
#	red   = -abs( y - ( height / 2 ) + f1 ) + 1.2
#	green = red / 2 + sin( x * 2 / width + time) * 0.8
#	blue  = red / 4 + cos( x * 2 / width + time) * 0.8

func formula_11( x, y ):
#rainbow sine wave
	$CanvasLayer/formula.text = "formula:\nf = 14.0 * sin( ( x + time * 12 ) / 24.0) \n"
	var f1 = 14.0 * sin( ( x + time * 12 ) / 24.0)
	red   = -abs( y - ( height / 2 ) + f1 ) + 1.2
	green = red / 2 + sin( x * 2 / width + time) * 0.8
	blue  = red / 4 + cos( x * 2 / width + time) * 0.8
	
func formula_12( x, y ):
# two parabolas
	$CanvasLayer/formula.text = "formula:\nm  = 6 / pow( time, 2 )\nf1 =  ( 2 - m ) * pow( x - width / 2, 2.0 ) / 120\nf2 =  (-2 + m ) * pow( x - width / 2, 2.0 ) / 120"
	var m  = 6 / pow( time, 2 )
	
	var f1 =  ( 2 - m ) * pow( x - width / 2, 2.0 ) / 120
	var f2 =  (-2 + m ) * pow( x - width / 2, 2.0 ) / 120
	
	red   = -abs(y -         (2.5*height/3) + 12 * m + f1) + 1.3
	green = -abs(y - (height-(2.5*height/3) + 12 * m)+ f2) + 1.3
	blue  = green
	
func formula_13( x, y ):
#combined triangle waves
	$CanvasLayer/formula.text = ""

	var f1 = ( 14.0 * asin( sin( ( ( x + time * 12 ) / 24.0 ) ) ) ) + ( 14.0 * acos( cos( ( ( x - time * 12 ) / 36.0 ) ) ) ) 
	red   = -abs( y - ( height / 2 ) + f1 ) + 1.2
	blue  = red / 5 + .3 * sin( x * 20 / width + time ) *.8
	green = red / 3 + .15 * sin( ( x + width / 6 ) * 20 / width + time ) *.8
	
func formula_14( x, y ):
#circle
	$CanvasLayer/formula.text = "circle = sqrt( pow ( x - offset, 2 ) + pow( y - offset, 2 ) )"
	var offset = width/2
	var f1 = 0
	var margin = 2
	var r = 52
	
	var circle = sqrt(pow(x-offset,2)+pow(y-offset,2))
	if abs(circle-r)<margin:
		f1=1.5-abs(circle-r)
	
	green = f1
	red = f1-abs(sin((x+time*100)/width))
	blue = f1
func formula_15( x, y ):
#diamond
	$CanvasLayer/formula.text = "dia = abs( x ) + abs( y )\nf1 = ( margin - pow( ( abs( dia - radius ) ), 2 ) / 12.0 ) / margin"
	var offset = - width/2
	var f1     = 0
	var margin = 1
	var radius = 30
	
	x += offset; y += offset
	var dia = abs(x)+abs(y)
	f1 = (margin-pow((abs(dia-radius)),2)/12.0)/margin
	red = 0
	blue = 0
	green = f1
	
		
func formula_16( x, y ):
#hexagon
	$CanvasLayer/formula.text = "hex = 2*abs(x)+abs(x-y*sqrt(3))+abs(x+y*sqrt(3))\nf1 = (margin-pow((abs(hex-radius)),2)/12.0)/margin"
	var offset = width/2
	var f1 = 0
	var margin = 5
	var radius = 150
	
	x -= offset; y -= offset
	var hex = 2*abs(x)+abs(x-y*sqrt(3))+abs(x+y*sqrt(3))
	f1 = (margin-pow((abs(hex-radius)),2)/12.0)/margin
	red = f1
	blue = 0
	green = 0
	
	x += offset; y += offset
	
func formula_17( x, y ):
# heart
	$CanvasLayer/formula.text =""
	var offset = -width/2; var f1 = 0; var r = 120
	
	x += offset; y += offset
	var heart = -pow((pow(x/r,2)+pow(y/r,2)-1),3) - pow(x/r,2)*pow(y/r,3)
	f1 = sign(heart);
	x -= offset; y -= offset
	
	var stripe = pow((cos(2*(x-y+60*time)/width)),6)
	blue = .7*f1 * sqrt(heart)*stripe 
	green = .35*f1 + .12*f1*stripe*(f1+1) 
	red = 0.9*f1+stripe*(f1+1) 
	
func formula_18( x, y ):
	$CanvasLayer/formula.text ="color = abs( int( pow(x,2.0) + pow(y,2.0) ) ) % int( time + 1)"
	blue  = abs(int(pow(x,2.0)+pow(y,2.0))) % int(time+1)
#	blue  =fmod(abs(pow(x,2.0)+pow(y,2.0)), time+1)
	green = 0.45*blue
	red   = 0.20*blue
	
func formula_19( x, y ):
	$CanvasLayer/formula.text ="color = fmod( abs( pow( x, 2.0 ) + pow( y, 2.0 ) ), time + 1)"
#	blue  = abs(int(pow(x,2.0)+pow(y,2.0))) % int(time+1)
	blue  = fmod(abs(pow(x,2.0)+pow(y,2.0)), time+1)
	green = 0.45*blue
	red   = 0.20*blue
	
func formula_20( x, y ):
#pattern changes depending on the value of power
	$CanvasLayer/formula.text ="power = int(time)\nf1 = sin(time*-5+sqrt(pow(x+offset,power)+pow(y+offset,power)))"
	var power = int(time)
	var offset = int(-width/2)*((power-1)%2)
	var f1 = sin(time*-5+sqrt(pow(x+offset,power)+pow(y+offset,power)))
	var f2 = sin(time*-4+sqrt(pow(x+offset,power)+pow(y+offset,power)))+blue
	
	blue = f1*0.4-0.4*randf()
	red = f1 - f2 + blue 
	green = red*(0.4+0.1*sin(2*(x+y)/width+time*8))
	
func formula_21( x, y ):
#blancmange, doubly periodic
	var a = 2*height/3 #amplitude
	var p = 2*width   #period
	
	var f1 = 0
	for n in range(int(time)):
		f1 += abs(2/pow(2,n)*a/PI*asin(sin(2*pow(2,n)*PI/p*x)))
	
	blue = sin(.8*(-abs(y+height+f1)+2*abs(sin(PI/width*(x-width)))+.35))
	green = 1.2*blue*(abs(sin(PI/width*(x-width)))+.35)
	red = 0.6*green
	
func formula_22( x, y ):
#rosettes
	var f1 = .8*abs(fmod(acos(cos(time)),asin(sin(PI*x*y/height*(8*pow(2,int(4*abs((2*y-height))/height)))))))+.2
	blue = .1*(green + red)
	green = .35*red + f1/(4 + .4*sin((-x + y + 140*time)/3*width))
	red = f1
	
func formula_23( x, y ):
#misc. rippling texture
	var f1 = sin(2*time+(y/4*cos(time/3)+(x/2)-width/4)*((y/3)-height/4)/width)
	var f2 = -2*cos(11*time/9-11*(y^x)/9)
	blue = (f2+f1)/(2.5+green)
	green = (f2+f1)/(3+red)
	red = (f2+f1)/4*abs(cos(2*(x-y)/width+time))