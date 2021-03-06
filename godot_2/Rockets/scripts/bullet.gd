
extends Sprite

var velocity = Vector2()
var timer    = 0
var asteroid = Vector2()
var gravity  = Vector2()
var target   = Vector2()
var player   = null
var id       = 0

func _fixed_process(delta):
	asteroid = get_pos() - get_node("../../Asteroid").get_pos()
#	velocity  += 10000/clamp(asteroid.length_squared(),40,10000)         \
#	           * -asteroid.normalized()
	set_pos( get_pos() + velocity )
	
	timer = timer + delta
	if ( timer > 5 ):
		queue_free()
	
	if (id == 1):
		if ((player.get_pos() - get_pos()).length()<20):
			player.boom()
			queue_free()
	else:
		for node in get_node("../../rockets").get_children():
			if ((node.get_pos() - get_pos()).length()<20 && node.active == true):
				node.destroy()
				queue_free()
		if ( (get_node("../../Enemy").get_pos() - get_pos()).length() < 30 && get_node("../../Enemy").is_alive ):
			get_node("../../Enemy").destroy()
			queue_free()
	
func _ready():
	set_fixed_process(true)
	player = get_node("../../Spaceship")


