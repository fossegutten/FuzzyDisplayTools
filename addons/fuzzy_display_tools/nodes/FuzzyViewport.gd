tool
extends Viewport
class_name FuzzyViewport


onready var game_size : Vector2 = Vector2(
		ProjectSettings.get("display/window/size/width"), 
		ProjectSettings.get("display/window/size/height")
)

func _init():
	if Engine.editor_hint:
		transparent_bg = true
		handle_input_locally = false
		usage = USAGE_2D
		render_target_update_mode = UPDATE_ALWAYS

func _ready():
	# ensure UI viewport is correct size, maybe it shouldn't be required
	size = game_size
	
