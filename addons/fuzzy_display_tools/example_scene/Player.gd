extends Sprite

const SPEED := 200.0

export (String) var up := ""
export (String) var down := ""
export (String) var left := ""
export (String) var right := ""


func _process(delta):
	var dir := Vector2(
		Input.get_action_strength(right) - Input.get_action_strength(left),
		Input.get_action_strength(down) - Input.get_action_strength(up)
	)
	global_position += dir * SPEED * delta
