extends Camera2D
class_name FuzzyCamera2D

## Features:
# No jittering
# No 1-frame lag/delay, like default camera ( If used properly )
# Virtual size support, automatically zooms in to get the specified resolution.

## HOWTO use this script:
#  Create a camera follow target node, and set it from editor or script.
#  Put the camera last in the scene tree, because it should process after the follow target node.
#  The two previous steps fixes the issue where default camera lags 1 frame behind.
#  Manipulating regular zoom values does nothing, use zoom_f instead

export (NodePath) var follow_target_path : NodePath
var follow_target : Node2D


export (bool) var use_virtual_size := false
export (Vector2) var virtual_size := Vector2(320, 180)
export (float, EXP, 0.01, 10.0) var zoom_f := 1.0


func _ready():
	add_to_group("camera")
	follow_target = get_node(follow_target_path)


func _process(delta):
	if is_instance_valid(follow_target):
		global_position = follow_target.position
	else:
		follow_target = get_node(follow_target_path)
	
	if use_virtual_size and !is_zero_approx(zoom_f):
		zoom = Vector2(virtual_size.round() / get_viewport().size) / zoom_f
	else:
		zoom = Vector2.ONE * zoom_f
	
	global_position = global_position.snapped(zoom)
	
	force_update_scroll()


func get_camera_size() -> Vector2:
	return get_viewport().size * zoom
