extends Sprite

const ACCELERATION = 3000

var orientation = 0.0
var facing      = Vector2()
var radial_acce = 0.0

var velocity    = Vector2()
var force       = Vector2()

var bulletObject:PackedScene = load("res://bullet.tscn")

func _physics_process(delta):
	process_input()
	orientation += radial_acce
	radial_acce *=0.93
	facing = Vector2( cos(orientation) , sin(orientation) )
	
	position += velocity * delta
	velocity += force    * delta
	velocity *= 0.95
	
	$body.rotation = orientation
	update()

func process_input():
	force  = Vector2( 0.0, 0.0 )
	if Input.is_action_pressed("ui_up"):
		force = ACCELERATION * facing
	if Input.is_action_pressed("ui_down"):
		force = -ACCELERATION * facing
	if Input.is_action_pressed("ui_left"):
		radial_acce -= 0.005
	if Input.is_action_pressed("ui_right"):
		radial_acce += 0.005
	if Input.is_action_pressed("ui_select"):
		spawn_bullet()
		
func spawn_bullet():
	var new_bullet = bulletObject.instance()
	new_bullet.position = position
	new_bullet.rotation = orientation
	new_bullet.velocity = facing * 1000
	$"../bullets".add_child(new_bullet)
	
func _draw():
	draw_line(Vector2(), velocity * 1, Color(1,1,1), 3)