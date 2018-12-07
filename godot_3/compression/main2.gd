extends Node

var resolution   = Vector2(48,21)
var margin       = Vector2(1,1)
var block_object = load("res://block.tscn")
var label_object = load("res://label.tscn")
var block_size   = Vector2(20,26)

var frame_iteration = 0
var block_counter   = 0
var group_iteration = 0
var block_count     = 0
var timer = 1
var frame = 0
var capture = null
var process = true
var max_value = resolution.x * (block_size.x + margin.x)  * resolution.y * (block_size.y +margin.y)
var currnet_value = max_value

var blocks_population = [0,0,0]

var groups_start      = [1,1,1]
var groups            = [1,1,1]


var group_max = 0
var setup = true

func _ready():
	randomize()
	
func setup():
	var prev_y = 0
	var prev_group = 0

	for y in range( resolution.y ):
		for x in range( resolution.x ):
			var new_block = new_block( x, y )
			$blocks.add_child( new_block )
			
			if y > prev_y:
				prev_y = y
				if new_block.id_group == prev_group:
					new_block.set_group((new_block.id_group+1)%3)
			prev_group = new_block.id_group
					
#			groups_start[new_block.id_group] += new_block.size.x
#			groups[new_block.id_group] = groups_start[new_block.id_group]
			
	block_count = get_child_count()
	capture_screen()


	for k in range (5):
		$waves.blocks_history[0].append([])
		$waves.blocks_history[1].append([])
		$waves.blocks_history[2].append([])
		for i in range (15):
			$waves.blocks_history[0][k].append(0)
			$waves.blocks_history[1][k].append(0)
			$waves.blocks_history[2][k].append(0)
	
func new_block( x, y ):
	var new_block      = block_object.instance()
	new_block.size     = block_size
	new_block.target_size = block_size
	new_block.position = Vector2( x * block_size.x + x * margin.x , y * block_size.y + y * margin.y ) +self.position+Vector2(10,10)
	return new_block


func _process(delta):
	if timer < 0:
		var group_size   = 0
		var id_group     = 0
		if process == true:
			id_group         = $blocks.get_child(0).id_group
			var new_position = $blocks.get_child(0).position
			for block in $blocks.get_children():
				if id_group == block.id_group:
					group_size      += 1
				else:
					merge_blocks(new_position, group_size, id_group)
					new_position = block.position
					id_group     = block.id_group
					group_size   = 1
				block.queue_free()
			merge_blocks(new_position, group_size, id_group)
			group_max = max( max(groups_start[0],groups_start[1]),groups_start[2]  )
			process = false
			capture_screen()
		else:
#			pass
			currnet_value = 0

			var current_possition = Vector2()
			for i in range(3):
				groups[i] = 0
				if frame % 5 == 1:
					for m in range(15):
						$waves.blocks_history[i][1][m] = $waves.blocks_history[i][0][m]
				if frame % 5 == 2:
					for m in range(15):
						$waves.blocks_history[i][2][m] = $waves.blocks_history[i][1][m]
				if frame % 5 == 3:
					for m in range(15):
						$waves.blocks_history[i][3][m] = $waves.blocks_history[i][2][m]
				if frame % 5 == 4:
					for m in range(15):
						$waves.blocks_history[i][4][m] = $waves.blocks_history[i][3][m]
						
				for m in range(15):
					$waves.blocks_history[i][0][m] = 0
					
			for block in $Node2D.get_children():
				groups[block.id_group] += block.size.x
				if current_possition.x + block.size.x >= resolution.x*(block_size.x + margin.x):
					current_possition.y += block_size.y + margin.y
					current_possition.x = 0
				block.position = current_possition + Vector2(10,10)
				current_possition.x += block.size.x + margin.x
				
				$waves.blocks_history[block.id_group][0][block.group_size-1] += block.size.x
				
			currnet_value = resolution.x*(block_size.x + margin.x)  * (current_possition.y) + current_possition.x * (block_size.y +margin.y) 
			blocks_population[0] = groups[0]/group_max
			blocks_population[1] = groups[1]/group_max
			blocks_population[2] = groups[2]/group_max
#			print(groups[0]," ",groups[1]," ",groups[2])
			$"bars/Label".text  = str(groups[0] / groups_start[0])
			$"bars/Label2".text = str(groups[1] / groups_start[1])
			$"bars/Label3".text = str(groups[2] / groups_start[2])
			capture_screen()
			
	else:
		if setup:
			setup = false
			update()
			setup()
		timer-=delta
		
func merge_blocks( new_position, group_size, id_group ):
	new_position -= self.position
	var new_block =  new_block( new_position.x, new_position.y )
	
	new_block.size.x     = block_size.x * group_size + margin.x * (group_size-1)
	new_block.position   = new_position
	new_block.group_size = group_size
	
	$Node2D.add_child( new_block )
	
	if group_size>1:
		new_block.get_node("Label").text    = str(group_size)
		new_block.get_node("Label").visible = true
	$waves.blocks_history[id_group][0][new_block.group_size-1] += new_block.size.x 
	new_block.set_group( id_group )
	
	groups_start[id_group] += new_block.size.x
	groups[id_group]        = groups_start[id_group]

func capture_screen():
	frame+=1
#	get_viewport().queue_screen_capture()
	capture = get_viewport().get_texture().get_data()
	capture.flip_y()
	capture.save_png("res://render/"+str(frame)+".png")
	pass

#func _draw():
#	draw_rect( Rect2(Vector2(), Vector2( 1028, 586 ) ), Color(0.14, 0.0, 0.20, 1), true) 
#	draw_rect( Rect2(Vector2(), Vector2( 1028, 586 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#	draw_rect( Rect2(Vector2(1,1), Vector2( 1026, 584 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#	for i in range(22):
#		draw_line(Vector2(0, 27 * i + 10 ), Vector2( 1026, 27 * i + 10 ), Color(0.7, 0.0, 1, 0.1))
#	for i in range(49):
#		draw_line(Vector2(21*i+10, 0 ), Vector2( 21*i+10, 586 ), Color(0.7, 0.0, 1, 0.1))
#
#	draw_rect( Rect2(Vector2(0, 600), Vector2( 1028, 300 ) ), Color(0.14, 0.0, 0.20, 1), true) 
#	draw_rect( Rect2(Vector2(0, 600), Vector2( 1028, 300 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#	draw_rect( Rect2(Vector2(1,601), Vector2( 1026, 300 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#
#	for i in range(15):
#		draw_line(Vector2(0, 21 * i + 610 ), Vector2( 1026, 21 * i + 610 ), Color(0.7, 0.0, 1, 0.1))
#	for i in range(49):
#		draw_line(Vector2(21 * i + 10, 600 ), Vector2( 21 * i + 10, 900 ), Color(0.7, 0.0, 1, 0.1))
#
#
#	draw_rect( Rect2(Vector2(1045, 600), Vector2( 800, 300 ) ), Color(0.14, 0.0, 0.20, 1), true) 
#	draw_rect( Rect2(Vector2(1045, 600), Vector2( 800, 300 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#	draw_rect( Rect2(Vector2(1046, 601), Vector2( 798, 300 ) ), Color(0.24, 0.0, 0.40, 0.95), false) 
#
#	for i in range(15):
#		draw_line(Vector2(1045, 21 * i + 610 ), Vector2( 1845, 21 * i + 610 ), Color(0.7, 0.0, 1, 0.1))
#	for i in range(41):
#		draw_line(Vector2(21 * i + 1035, 600 ), Vector2( 21 * i + 1035, 900 ), Color(0.7, 0.0, 1, 0.1))

