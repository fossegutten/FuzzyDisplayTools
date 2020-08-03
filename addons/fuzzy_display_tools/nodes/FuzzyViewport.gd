tool
extends Viewport
class_name FuzzyViewport

# Hacky button
export (bool) var reset_size_button := false setget reset_size_hack

# Godot Engine bug? 
# The inspector UI does not update until another node is selected
func reset_size_hack(value : bool) -> void:
	if value:
		size = get_main_viewport_size()
		print_debug("%s size changed to: %s. Select another node to update Inspector." % [self.name, size])
	reset_size_button = false


func _init():
	if Engine.editor_hint:
		transparent_bg = true
		handle_input_locally = false
		usage = USAGE_2D
		render_target_update_mode = UPDATE_ALWAYS
		size = get_main_viewport_size()


func get_main_viewport_size() -> Vector2:
	return Vector2(
		ProjectSettings.get("display/window/size/width"), 
		ProjectSettings.get("display/window/size/height")
	)
