extends Node2D


func _process(delta):
	var pos : Vector2
	
	for i in get_tree().get_nodes_in_group("player"):
		pos += i.global_position
	
	global_position = pos / get_tree().get_nodes_in_group("player").size()
