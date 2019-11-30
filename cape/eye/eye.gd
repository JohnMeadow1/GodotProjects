tool
extends Node2D
var previous_position = Vector2.ZERO
var distance_threshold := 0.0
var velocity           := Vector2.ZERO
export(int) var eye_size := 100 setget set_eye_size
export(int) var iris_size := 30 setget set_iris_size
export(Vector2) var gravity := Vector2(0,100) setget set_gravity

func _ready():
	update_threshold()
	
func set_eye_size(value):
	eye_size = max( value, 2 )
	$white.scale = Vector2(1.0,1.0) * eye_size / 250.0
	$gloss.scale = $white.scale
	update_threshold()
	
func set_iris_size(value):
	iris_size = max( value, 1 )
	if has_node("iris/black"):
		$iris/black.scale = Vector2(1.0,1.0) * ( iris_size / 150.0 )
	update_threshold()
	
func set_gravity(value):
	gravity = value
	
func update_threshold():
	previous_position = global_position 
	distance_threshold = ( eye_size * 0.5 - eye_size * 0.06 ) - ( iris_size * 0.5 )
	
func _physics_process(delta):
	global_rotation = 0
	velocity += gravity * delta
	$iris.position += ( previous_position - global_position )
#	$iris.position += ( previous_position - global_position )
	$iris.position += velocity * delta
	if $iris.position.length() > distance_threshold:
		velocity -= (( $iris.position.length() - distance_threshold) * $iris.position.normalized())/delta * 1.5
		$iris.position = distance_threshold * $iris.position.normalized()
		
	velocity *=  0.99
	previous_position = global_position
#	position = get_global_mouse_position()
