extends Node

var resolution   = Vector2(50,20)
var margin       = Vector2(2,2)
var block_object = load("res://block.tscn")
var label_object = load("res://label.tscn")
var block_size   = Vector2(20,30)

var frame_iteration = 0
var block_counter   = 0
var group_iteration = 0
var block_count     = 0
var timer = 0

func _ready():
	for y in range( resolution.y ):
		for x in range( resolution.x ):
			$blocks.add_child( new_block( x, y ) )
	block_count = get_child_count()

func new_block( x, y ):
	var new_block      = block_object.instance()
	new_block.size     = block_size
	new_block.target_size = block_size
	new_block.position = Vector2( x * block_size.x + x * margin.x , y * block_size.y + y * margin.y )
	return new_block

	
func _process(delta):
	if timer < 0:
		var group_size  = 0
		var id_group    = 0
		group_iteration = frame_iteration

		if $blocks.get_child_count()>0:
			id_group    = $blocks.get_child(group_iteration).id_group
		#	var position    = $blocks.get_child(group_iteration).position
			while id_group == $blocks.get_child(group_iteration).id_group:
#				print(group_iteration," ", $blocks.get_child_count())
				group_iteration += 1
				group_size      += 1
				if group_iteration >= $blocks.get_child_count():
					$blocks.get_child(group_iteration-1).queue_free()
					break
				else:
					$blocks.get_child(group_iteration-1).queue_free()
			
#			if group_size > 1:
#				var new_label      = label_object.instance()
#				new_label.size     = block_size
#				new_label.get_node("Label").text    = str(group_size)
#				new_label.set_group( id_group )
#				$Node2D.add_child(new_label)
#				var new_position = Vector2( block_counter % int(resolution.x), floor(block_counter / resolution.y) )
#				new_label.position = Vector2( new_position.x * block_size.x + new_position.x * margin.x, new_position.y * block_size.y + new_position.y * margin.y)
#				block_counter   += 1
			var new_position   = Vector2(block_counter % int(resolution.x), floor(block_counter / resolution.x))
#			print (block_counter, group_size,  new_position)
			var new_block =  new_block( new_position.x, new_position.y )
			new_block.target_size.x = block_size.x * group_size
			$Node2D.add_child( new_block )
			if group_size > 1:
#				new_block.double = true
				new_block.get_node("Label").text    = str(group_size)
				new_block.get_node("Label").visible = true
			new_block.set_group( id_group )
#			frame_iteration +=1
				
			block_counter += 1
	else:
		timer-=delta