
extends Node2D

export var spread = 1
var dust          = []
var player        = null
var player_pos    = Vector2()
var xi = 0
var yi = 0

func _fixed_process(delta):
	if( (player.get_pos().x - player_pos.x) > spread ):
		update_bg_x( 1 )
	if( (player.get_pos().x - player_pos.x) < -spread ):
		update_bg_x( -1 )
		
	if( (player.get_pos().y - player_pos.y) > spread ):
		update_bg_y( 1 )
	if( (player.get_pos().y - player_pos.y) < -spread ):
		update_bg_y( -1 )

func update_bg_x( operator ):
	xi = int(floor(player.get_pos().x) / spread)
	for i in range(7):
		dust[ i * 10 + xi % 10 ] = Vector2( (xi) * spread, ( yi + i ) * spread )

	player_pos.x = player.get_pos().x
	update()
	
func update_bg_y( operator ):
	yi = int(floor(player.get_pos().y) / spread)
	for i in range(10):
		dust[ i + (yi % 7) * 10 ] = Vector2( ( xi + i ) * spread, ( yi ) * spread )

	player_pos.y = player.get_pos().y
	update()
	
func _ready():
	spread *= 100
	set_fixed_process( false )
	player = get_node("../../Spaceship")
	player_pos = player.get_pos()
	dust.resize(560)
	for i in range(560):
		var x = ( i % 40 )
		var y = floor( i / 40 )
		dust[i] = Vector2( x * spread, y * spread )
		pass
	pass
#	update()

func _draw():
	for i in range( 560 ):
		draw_circle( dust[i]+Vector2(rand_range(0,100),rand_range(0,100)), 1, Color(0, 0, 0, rand_range(0.3,1)))
#		print(dust[i])



