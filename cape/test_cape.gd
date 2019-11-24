extends Node2D

var timer := 0.0
var iterator :int = 0
var previous_position := Vector2()
var previous_mouse_position := Vector2()
var direction := Vector2()

var wind_direction := Vector2()
var wind_direction_target := Vector2()
var wind_strength := 250.0
var wind_strength_target := 250.0


func _ready():
	randomize()
	pass # Replace with function body.

func _physics_process(delta):
	timer += delta
	iterator %= (randi()%100 +1)
	if iterator == 0:
		var new_direction = rand_range(-PI, PI)
		wind_direction_target = Vector2(cos(new_direction),sin(new_direction))
		wind_strength_target = rand_range( 100, 250 )
	iterator += 1
		
	wind_direction = lerp(wind_direction, wind_direction_target, 0.1)
	wind_strength = lerp(wind_strength, wind_strength_target, 0.1)
	$Label.text = "Force: " +str(int(wind_strength))
	direction = (previous_position - get_global_mouse_position())
	direction = Vector2(0,1) * max(1 - direction.length()*0.05, 0) + direction.normalized() * min(direction.length()*0.05, 1)
	$Sprite.rotation = lerp_angle($Sprite.rotation, Vector2.DOWN.angle_to(direction),0.2)
	$Sprite.position = lerp( $Sprite.position, get_global_mouse_position(), 0.1 )
#	direction = wind_direction
	previous_position = $Sprite.position
	previous_mouse_position =  get_global_mouse_position()
	$Cape.apply_velocity(wind_direction * wind_strength, delta)
	
	update()

func _draw():
	draw_circle(Vector2(50,50), 25, Color.darkgray)
	draw_circle_arc(Vector2(50,50), 25, Color.white)
	draw_line(Vector2(50,50), Vector2(50,50) + wind_direction * wind_strength * 0.1, Color.yellow, 3)
	
func draw_circle(center, radius, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = float(i)*PI*2 / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func draw_circle_arc(center, radius, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = float(i)*PI*2 / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2 )
		
		
