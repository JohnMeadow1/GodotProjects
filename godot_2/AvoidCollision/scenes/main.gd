
extends Node2D

var vectorField         = Vector2Array()
var bulletObject        = preload("res://scenes/bullet.scn")

func _fixed_process(delta):
	update()
	
func calculate_vector( localPosition ):
	
	var force = Vector2()
	var vectorToObject = Vector2()
	var vectorToObjectLength = 0.0
	
	for obiekt in get_node("obiekty").get_children():
		vectorToObject = localPosition - obiekt.get_pos() 
		vectorToObjectLength = vectorToObject.length() - obiekt.radius
		
		if ( vectorToObjectLength > 0 ):
			force += vectorToObject.normalized() * obiekt.mass / vectorToObjectLength
			
	for obiekt in get_node("bullets").get_children():
		vectorToObject       = localPosition - obiekt.get_pos() 
		vectorToObjectLength = vectorToObject.length_squared()
		
		if ( vectorToObjectLength > 0 ):
			force += vectorToObject.normalized() * 1000 / vectorToObjectLength
			
	return force.normalized() * min(force.length(), 18) 

	
func generateBullet( bulletPosition, bulletValocity ):
	var bullets = get_node("bullets")
	
	var new_bullet = bulletObject.instance()
	new_bullet.set_pos( bulletPosition )
	new_bullet.velocity = (bulletValocity + Vector2(rand_range(-0.03,0.03),rand_range(-0.03,0.03))) *10
	
	bullets.add_child( new_bullet )

func _draw():
	var vec = Vector2()
	for i in range(1200):
		vec.x = (i % 40) * 20
		vec.y = (floor(i/40)) * 20
		vectorField[i] = calculate_vector (vec)
		
		draw_line( vec, vec + vectorField[i].normalized() * clamp(vectorField[i].length_squared(),1,15), Color(1,1,1))
#	
	
func _ready():
	set_fixed_process(true)
	vectorField.resize(1200)
	