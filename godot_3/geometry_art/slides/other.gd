extends Node2D

var ds = 5 # dimensions of each square
var width = 128; var height = 128# dimensions of the image
var t = 0# initial time
var r = 0; var g = 0; var b = 0 # default color values
var h = float(height); var w = float(width)
var function_id = 17

func _ready():
	OS.set_window_size(Vector2(width*ds, height*ds))
#	set_process(true)
	set_process_input(true)
	var x = 100
	var y = 100
#	print(w)
	print(int(acos(8)))
#	for x in range( 0, 10, 1 ):
#		print ( "%20.18f" % acos(float(x)/10) )

func _input(event):
	if event.is_action_pressed("Next") && function_id<18: function_id += 1
	if event.is_action_pressed("Prev") && function_id>1 : function_id -= 1

func _process(delta):
	update();
	t += delta
#	print("%20.18f" %tan((y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w))
#	if t > 1:
#		t = -1

func _draw():
#	for x in range(width):
#		draw_rect(Rect2(Vector2(x*ds,h/2+acos(float(x*4-width*2)/width*2)*width),Vector2(ds,ds)),Color(1,1,1))
	for x in range(width):
		for y in range(height):
			call('formula_'+str(function_id),x,y)
			draw_rect(Rect2(Vector2(x*ds,y*ds),Vector2(ds,ds)),Color(r,g,b))
#	var x = 100
#	var y = 100
#	print(tan((y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w))
func formula_1( x, y ):
	#simple gradient
	r = x/w
	b = (w-x)/w

func formula_2( x, y ):
# two parabolas
	var m = 3/pow(t,2)

	var f1 =   (2-m)*pow(x-w/2,2.0) / 120
	var f2 =  (-2+m)*pow(x-w/2,2.0) / 120

	r = -abs(y -    (2.5*h/3) + 12 * m + f1) + 1.3
	g = -abs(y - (h-(2.5*h/3) + 12 * m)+ f2) + 1.3
	b = g

func formula_3( x, y ):
#blancmange fractal curve
	var a = 2*h/3 #amplitude
	var p = 2*w   #period

	var f1 = 0
	for n in range(int(2*t)):
		f1 += abs(2/pow(2,n)*a/PI*asin(sin(2*pow(2,n)*PI/p*x)))

	g = .6*(-abs(y-h+f1)+2*abs(cos(PI/w*(x-w/2)))+.35)
	b = .5*g*(abs(sin(PI/w*(2*x-w)))+.35)
	r = .4*b

func formula_4( x, y ):
#combined triangle waves
	var f1 = (14.0*asin(sin(((x+t*12)/24.0)))) + (14.0*acos(cos(((x-t*12)/36.0))))
	r = -abs(y-(h/2)+f1)+1.2
	b = r/5+.3*sin(x*20/w+t)*.8
	g = r/3+.15*sin((x+w/6)*20/w+t)*.8

func formula_5( x, y ):
#rainbow sine wave
	var f1 = 14.0*sin((x+t*12)/24.0)
	r = -abs(y-(h/2)+f1)+1.2
	g = r/2+sin(x*2/w+t)*0.8
	b = r/4+cos(x*2/w+t)*0.8

func formula_6( x, y ):
#cool looking sine wave
	var f1 = 14.0*sin((x+t*12)/24.0)
	var f2 = 14.0*sin((x+t*12)/24.0)

	var gain = 0.6+abs(clamp(tan(x/130.0-t),-5,5))

	r = -abs(y-(h/2)-sin(f1/6.00)*12) +gain
	b = -abs(y-(h/2)-tan(f1/12.0)*7.5)+gain
	g = -abs(y-(h/2)-f2)              +gain+r/4

func formula_7( x, y ):
#circle
	var offset = w/2
	var f1 = 0
	var margin = 2
	var r = 110

	var circle = sqrt(pow(x-offset,2)+pow(y-offset,2))
	if abs(circle-r)<margin:f1=1.5-abs(circle-r)

	g = f1
	r = f1-abs(sin((x+t*100)/w))
	b = f1

func formula_8( x, y ):
#diamond
	var offset = -w/2
	var f1 = 0
	var margin = 1
	var radius = 110

	x += offset; y += offset
	var dia = abs(x)+abs(y)
	f1 = (margin-pow((abs(dia-radius)),2)/12.0)/margin
	r = 0; b = 0; g = f1

func formula_9( x, y ):
#triangle
	var offset = w/2
	var f1 = 0
	var margin = 10
	var size = 50

	x += offset;y += offset/1.4
	var tri = max2([-2*y,y-x*sqrt(3),y+x*sqrt(3)])

	var error = abs(tri-size)
	if error<margin: f1 = 1-error/5
	r = f1; g = f1; b = 0

func max2(v):
	if ( v[0]>v[1] && v[0]>v[2] ):
		return v[0]
	elif ( v[1]>v[0] && v[1]>v[2] ):
		return v[1]
	elif ( v[2]>v[0] && v[2]>v[1]):
#	else:
		return v[2]

func formula_10( x, y ):
#hexagon
	var offset = w/2
	var f1 = 0
	var margin = 5
	var radius = 400

	x -= offset; y -= offset
	var hex = 2*abs(x)+abs(x-y*sqrt(3))+abs(x+y*sqrt(3))
	f1 = (margin-pow((abs(hex-radius)),2)/12.0)/margin
	r = f1; b = 0; g = 0

	x += offset; y += offset

func formula_11( x, y ):
# heart
	var offset = -w/2; var f1 = 0; var r = 120

	x += offset; y += offset
	var heart = -pow((pow(x/r,2)+pow(y/r,2)-1),3) - pow(x/r,2)*pow(y/r,3)
	f1 = sign(heart);
	x -= offset; y -= offset

	var stripe = pow((cos(2*(x-y+60*t)/w)),6)
	b = .7*f1 * sqrt(heart)*stripe
	g = .35*f1 + .12*f1*stripe*(f1+1)
	r = 0.9*f1+stripe*(f1+1)

func formula_12( x, y ):
#(x^2+y^2) mod n solutions:
	b = -abs(x^2+y^2)%int(t)+1
	g = 0.45*b
	r = 0.20*b

func formula_13( x, y ):
#pattern changes depending on the value of power
	var power = int(t)
	var offset = int(-w/2)*((power-1)%2)
	var f1 = sin(t*-5+sqrt(pow(x+offset,power)+pow(y+offset,power)))
	var f2 = sin(t*-4+sqrt(pow(x+offset,power)+pow(y+offset,power)))+b

	b = f1*0.4-0.4*randf()
	r = f1 - f2 + b
	g = r*(0.4+0.1*sin(2*(x+y)/w+t*8))

func formula_14( x, y ):
#blancmange, doubly periodic
	var a = 2*h/3 #amplitude
	var p = 2*w   #period

	var f1 = 0
	for n in range(int(t)):
		f1 += abs(2/pow(2,n)*a/PI*asin(sin(2*pow(2,n)*PI/p*x)))

	b = sin(.8*(-abs(y+h+f1)+2*abs(sin(PI/w*(x-w)))+.35))
	g = 1.2*b*(abs(sin(PI/w*(x-w)))+.35)
	r = 0.6*g

func formula_15( x, y ):
#rosettes
	var f1 = .8*abs(fmod(acos(cos(t)),asin(sin(PI*x*y/h*(8*pow(2,int(4*abs((2*y-h))/h)))))))+.2
	b = .1*(g + r); g = .35*r + f1/(4 + .4*sin((-x + y + 140*t)/3*w)); r = f1

func formula_16( x, y ):
#misc. rippling texture
	var f1 = sin(2*t+(y/4*cos(t/3)+(x/2)-w/4)*((y/3)-h/4)/w)
	var f2 = -2*cos(11*t/9-11*(y^x)/9)
	b = (f2+f1)/(2.5+g)
	g = (f2+f1)/(3+r)
	r = (f2+f1)/4*abs(cos(2*(x-y)/w+t))

func formula_17( x, y ):
	g = 0.72 * rand_range(0.2,0.3*tan((y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w))+b
#	g = 0.72 * 0.3*tan((y-int(acos(t*4)*10)*10*y%(40*x+1)-t*18.0)/w)+b
#	g = 0.12 * tan((y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w)+b
#	g = 0.12 * (y-int(acos(t*4)*10)*y%(40*x+1)-t*18.0)/w+b
#	g = 0.12 * (y-int(acos(t*4)*10)*y%(40*x+1))/w
	g = 0.12 * 1-(int(acos(4))*x % (x+1)/w)
#	g = 0.92 * acos(t*4)*(y%(40*x+1))
#	g = 0.72 * (y%(40*x+1))/w
#	g = 0.12 * (y-(int(acos(float(t*4))*10)*y)%(40*x+1))/w
	b = 0.38 * g
	r = g-b

func formula_18( x, y ):
#matrix effect
	g = cos(t) + cos(6*t)/2 + sin(14*t)/3 + (sin(t) + sin(6*t)/2 + cos(14*t)/3)*x/w
	b=0.38*cos(t) + cos(6*t)/2 + sin(14*t)/3 + (sin(t) + sin(6*t)/2 + cos(14*t)/3)*y/h
	r=g-b

