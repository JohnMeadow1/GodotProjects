extends Node2D

var move_speed := 100.0

func _process(delta):
	position.y -= move_speed * delta
	if position.y <= -20:
		queue_free()

func _on_bullet_area_entered(area):
	queue_free()
