extends Sprite


const SPEED := 200.0


func _process(delta):
	var dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	global_position += dir * SPEED * delta
