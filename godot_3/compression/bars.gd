extends Node2D


func _process(delta):
	update()
	
func _draw():
	draw_rect( Rect2(Vector2(0, 0), Vector2( $"..".groups[0] / $"..".groups_start[0] * 760.0, 80 ) ), Color(0.13,0.28,0.43), true) 
	draw_rect( Rect2(Vector2(0, 0), Vector2( $"..".groups[0] / $"..".groups_start[0] * 760.0, 80 ) ), Color(0.7, 0.0, 1,0.5), false) 

	draw_rect( Rect2(Vector2(0, 95), Vector2( $"..".groups[1] / $"..".groups_start[1] * 760.0, 80 ) ), Color(0.43,0.13,0.4), true) 
	draw_rect( Rect2(Vector2(0, 95), Vector2( $"..".groups[1] / $"..".groups_start[1] * 760.0, 80 ) ), Color(0.7, 0.0, 1,0.5), false) 

	draw_rect( Rect2(Vector2(0, 190), Vector2( $"..".groups[2] / $"..".groups_start[2] * 760.0, 80 ) ), Color(0.23,0.13,0.43), true) 
	draw_rect( Rect2(Vector2(0, 190), Vector2( $"..".groups[2] / $"..".groups_start[2] * 760.0, 80 ) ), Color(0.7, 0.0, 1,0.5), false) 
