extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var is_walking = false
var motion = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	motion = Vector2(0,0)
	is_walking = false
	if Input.is_action_pressed("left"):
		motion.x -= 1
		is_walking = true
	
	if Input.is_action_pressed("right"):
		motion.x += 1
		is_walking = true
	
	if Input.is_action_pressed("up"):
		motion.y -= 1
		is_walking = true
	
	if Input.is_action_pressed("down"):
		motion.y += 1
		is_walking = true
	
#	motion *= 0.90
	move_and_slide(motion*500)
	
	if is_walking == false:
#		$Sprite/AnimationPlayer.stop()
		pass
	else:
		if not $Sprite/AnimationPlayer.is_playing():
			$Sprite/AnimationPlayer.play("walk")

	pass
