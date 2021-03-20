extends Node2D
class_name Player

onready var sprite := $Sprite as Sprite

export(String) var player_id = "1"
var speed    := 100
var is_alive := true

func _ready() ->void:
	if player_id == "2":
		pass
	pass

func _process( delta:float ) ->void:
	if Input.is_action_pressed("player_"+player_id+"_down"):
		position.y += speed * delta
		sprite.frame = 0
	elif Input.is_action_pressed("player_"+player_id+"_up"):
		position.y -= speed * delta
		sprite.frame = 9
	elif Input.is_action_pressed("player_"+player_id+"_right"):
		position.x += speed * delta
		sprite.frame = 3
	elif Input.is_action_pressed("player_"+player_id+"_left"):
		position.x -= speed * delta
		sprite.frame = 6
	if Input.is_action_just_pressed("player_"+player_id+"_shoot"):
		spaw_bullet()

func spaw_bullet() -> void:
	pass
