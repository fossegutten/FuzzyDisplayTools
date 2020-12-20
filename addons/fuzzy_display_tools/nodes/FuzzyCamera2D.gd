extends Camera2D
class_name FuzzyCamera2D


export (NodePath) var follow_target_path : NodePath
var follow_target : Node2D


export (bool) var use_virtual_size := true
export (Vector2) var virtual_size := Vector2(320, 180)
export (float, EXP, 0.01, 10.0) var zoom_f := 1.0


func _ready():
	add_to_group("camera")
	follow_target = get_node(follow_target_path)


func _process(delta):
	
	if !is_instance_valid(follow_target):
		follow_target = get_node(follow_target_path)
	
	if follow_target:
		global_position = follow_target.position
	
	if use_virtual_size and !is_zero_approx(zoom_f):
		zoom = Vector2(virtual_size.round() / get_viewport().size) / zoom_f
	else:
		zoom = Vector2.ONE * zoom_f
	
	snap_and_update_scroll()


# eliminates the jagging
func snap_and_update_scroll() -> void:
	var old_pos := global_position
	global_position = global_position.snapped(zoom)
	
	force_update_scroll()
	global_position = old_pos


func get_camera_size() -> Vector2:
	return get_viewport().size * zoom
