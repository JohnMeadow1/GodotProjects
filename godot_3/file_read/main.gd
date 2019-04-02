extends Node2D

#var dir_path = "sol/"
#var file = File.new()
var file_path = ""
var dir = Directory.new()
#var current_file = ""
var dir_array  = PoolStringArray()
var dir_iterator:int = 0
var file_array = PoolStringArray()
var file_iterator:int = 0

func _ready():
	$debug.text = ""
	dir_contents(".")
#	dir_contents(dir.get_current_dir())
#	dir_contents(dir_path)
	change_dir()
		
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		dir_iterator = clamp( dir_iterator-1, 0, dir_array.size()-1 )
		$debug.text = ""
		change_dir()
		
	if Input.is_action_just_pressed("ui_down"):
		dir_iterator = clamp( dir_iterator+1, 0, dir_array.size()-1 )
		$debug.text = ""
		change_dir()
		
	if Input.is_action_just_pressed("ui_left"):
		file_iterator = clamp( file_iterator-1, 0, file_array.size()-1 )
		$debug.text = ""
		load_curent_image()
		
	if Input.is_action_just_pressed("ui_right"):
		file_iterator = clamp( file_iterator+1, 0, file_array.size()-1 )
		$debug.text = ""
		load_curent_image()

func change_dir():
	file_iterator = 0
	$current_image/directory.text = dir_array[dir_iterator]
	dir_contents(dir_array[dir_iterator])
	load_curent_image()

func dir_contents(path):
	$debug.text += path+"\n"
	file_array = PoolStringArray()
	if dir.open(path) == OK:
		dir.list_dir_begin( true )
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				$debug.text += "dir:"+file_name+"\n"
				dir_array.append(file_name)
			else:
				$debug.text += "file:"+file_name+"\n"
				file_array.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func load_curent_image():
	$current_image.texture = load_image(file_array[file_iterator])
	$current_image/file.text = file_array[file_iterator]
	load_thumbnails()

func load_image(file_path):
		var img  = Image.new()
		var itex = ImageTexture.new()
		
		img.load(dir_array[dir_iterator]+"/"+file_path)
		itex.create_from_image(img)
		return itex
		
func load_thumbnails():
	var img  = Image.new()
	var itex = ImageTexture.new()
	var local_iterator = max( file_iterator - 4, 0 )
	for i in range(8):
		if local_iterator+1 <= file_array.size():
			get_node("mini_image"+str(i+1)).texture = load_image(file_array[local_iterator])
			get_node("Label"+str(i+1)).text = file_array[local_iterator]
			if file_iterator == local_iterator:
				get_node("mini_image"+str(i+1)).modulate.b = 0.8
			else:
				get_node("mini_image"+str(i+1)).modulate.b = 1.0
			local_iterator += 1
			get_node("mini_image"+str(i+1)).visible = true
			get_node("Label"+str(i+1)).visible = true
		else:
			get_node("mini_image"+str(i+1)).visible = false
			get_node("Label"+str(i+1)).visible = false