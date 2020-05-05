extends Sprite

var velocity = Vector2()
var timer    = 0.5
func _process(delta):
	position += velocity * delta
	
	timer -= delta
	if timer<0:
		queue_free()
