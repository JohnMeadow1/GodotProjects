extends Node2D

func _process(delta):
	pass

func _on_Area2D_area_entered(area):
	queue_free()
