extends Node2D

var bullet_object = load("res://bullet.tscn")

var move_speed := 100.0

var shoot_delay := 0.7
var shoot_timer := 0.0

func _process(delta):
	shoot_timer += delta
	
	if Input.is_action_pressed("ui_left") and position.x > 0:
		position.x -= move_speed * delta
	if Input.is_action_pressed("ui_right") and position.x < get_viewport_rect().size.x:
		position.x += move_speed * delta
	if Input.is_action_pressed("ui_select"):
		shoot()

func shoot():
	if shoot_timer >= shoot_delay:
		var new_bullet = bullet_object.instance()
		new_bullet.position = position
		get_parent().add_child(new_bullet)
		shoot_timer = 0.0
