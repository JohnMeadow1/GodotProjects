extends Sprite

var smoke = null
var smoke_size = 100.0
var m_last_pos = Vector2()

func _ready():
	var image_texture = ImageTexture.new()
	m_last_pos = Vector2(-1, -1)
	image_texture.create( smoke_size, smoke_size ,Image.FORMAT_L8 )
	smoke = Smoke.new()

	smoke.init( smoke_size, image_texture )

#	smoke.attach_density_source(100, 100, 16, 1);

#	smoke.attach_velocity_source(88.5, 110.5, 1.0, 0.0, 100)

	smoke.set_diffusion_rate(0.001)
	smoke.set_viscosity(0.0001)
	smoke.set_relaxation_iteration_count(5)

	self.set_texture( smoke.get_texture() )
#	set_process( true )

func _physics_process(delta):
	var m_pos = Vector2(50,80)
	var y = round(m_pos.y)
#	for i in range(3):
#		var x = round(m_pos.x + i)
#		smoke.add_density(x, y, rand_range(0,3))
#		smoke.add_velocity(x, y, 0, -rand_range(0,10))
#	smoke.add_density(x, y, 1.0)
	smoke.add_velocity(m_pos.x, m_pos.y, 0, -4)
	smoke.add_density(m_pos.x, m_pos.y, 3.0)
	# "click2" action is right mouse button click
	if Input.is_action_pressed("click_2"):
		var mp = get_viewport().get_mouse_position()
		for i in range(-5, 5):
			for j in range(-5, 5):
				smoke.add_density(int(mp.x) + i, int(mp.y) + j, 1.0)
	
	# "click" action is left mouse button click
#	if Input.is_action_pressed("click"):
#		var m_pos = get_viewport().get_mouse_position()
#		if m_last_pos.x > 0:
#			var m_change = m_pos - m_last_pos
#			m_change *= 2.0;
#			for i in range(5):
#				var x = floor(m_pos.x + rand_range(-2, 3))
#				var y = floor(m_pos.y + rand_range(-2, 3))
#				smoke.add_velocity(x, y, m_change.x, m_change.y)
#		m_last_pos = m_pos
#	else:
#		m_last_pos.x = -1.0
func _process(delta):
	smoke.update(delta)
