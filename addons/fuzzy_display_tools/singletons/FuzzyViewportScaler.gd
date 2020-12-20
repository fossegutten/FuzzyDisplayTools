extends Node

signal viewport_resized(scale)

## TODO: 
#  Check if removing black bars work
#  TODO add keep height / width modes

## HOWTO:
#  Add to AutoLoad in ProjectSettings (automatic if using the plugin)
#  Set base window size in ProjectSettings -> Window
#  Use stretch mode 'viewport' and aspect 'ignore' in ProjectSettings -> Window

onready var viewport = get_viewport()
onready var game_size : Vector2 = Vector2(
		ProjectSettings.get("display/window/size/width"), 
		ProjectSettings.get("display/window/size/height")
)

enum ScaleMode {
	STRETCH,
	KEEP_ASPECT,
}

export(ScaleMode) var scale_mode : int = ScaleMode.STRETCH setget set_scale_mode, get_scale_mode
export(bool) var pixel_perfect : bool = false setget set_pixel_perfect, is_pixel_perfect_enabled
export(bool) var integer_scaling : bool = true setget set_integer_scaling, is_integer_scaling_enabled

var viewport_scale : float = 1.0


func _ready():
	get_tree().connect("screen_resized", self, "update_viewport_rect")
	
	if ProjectSettings.has_setting("display/fuzzy_display_tools/pixel_perfect"):
		pixel_perfect = ProjectSettings.get("display/fuzzy_display_tools/pixel_perfect")
	if ProjectSettings.has_setting("display/fuzzy_display_tools/scale_mode"):
		scale_mode = ProjectSettings.get("display/fuzzy_display_tools/scale_mode")
	if ProjectSettings.has_setting("display/fuzzy_display_tools/integer_scaling"):
		scale_mode = ProjectSettings.get("display/fuzzy_display_tools/integer_scaling")
	
	update_viewport_rect()


func set_pixel_perfect(value : bool) -> void:
	pixel_perfect = value
	update_viewport_rect()


func set_integer_scaling(value : bool) -> void:
	integer_scaling = value
	update_viewport_rect()


func set_scale_mode(value : int) -> void:
	scale_mode = value
	update_viewport_rect()


func is_pixel_perfect_enabled() -> bool:
	return pixel_perfect


func is_integer_scaling_enabled() -> bool:
	return integer_scaling


func get_scale_mode() -> int:
	return scale_mode


func update_viewport_rect() -> void:
	if !is_inside_tree():
		return
	
	var window_size : Vector2 = OS.get_window_size()
	var aspect_ratio : float = game_size.x / game_size.y
	
	if pixel_perfect:
		viewport_scale = 1.0
	else:
		viewport_scale = floor(max(1, min(window_size.x / game_size.x, window_size.y / game_size.y)))
	
	# TODO calculate game width / height to fit screen, in keep height / width modes
	get_viewport().size = viewport_scale * game_size
	
	var target_rect : Rect2 = Rect2()
	
	
	match scale_mode:
		ScaleMode.STRETCH:
			target_rect.size = window_size
		ScaleMode.KEEP_ASPECT:
			var window_viewport_scale : Vector2 = window_size / viewport.size
			target_rect.size = game_size * viewport_scale * min(window_viewport_scale.x, window_viewport_scale.y)
	
	# clamp to game size
	target_rect.size.x = max(target_rect.size.x, game_size.x)
	target_rect.size.y = max(target_rect.size.y, game_size.y)
	
	if integer_scaling:
		# subtract modulo of game size
		target_rect.size.x -= fmod(target_rect.size.x, game_size.x)
		target_rect.size.y -= fmod(target_rect.size.y, game_size.y)
	
	# floor window pos, so we always go to the top left pixel, instead of jagging back and forth
	target_rect.position = (window_size / 2).floor() - (target_rect.size / 2) 
	
	# attach the viewport to the rect we calculated
	viewport.set_attach_to_screen_rect(target_rect)
	
	update_black_bars(target_rect)
	
	emit_signal("viewport_resized", viewport_scale)


func update_black_bars(target_rect : Rect2) -> void:
	# BUG(?) in Godot 3.x
	# because godot doesnt clear the render buffer when resizing the viewport rect, we add black bars
	var window_size := OS.get_window_size()
	
	var black_bars : Vector2 = (window_size - target_rect.size) / 2
	var odd_pixel : Vector2 = Vector2(int(window_size.x) % 2, int(window_size.y) % 2)
	
	if window_size.x < viewport.size.x:
		black_bars.x = 0
		odd_pixel.x = 0
	if  window_size.y < viewport.size.y:
		black_bars.y = 0
		odd_pixel.y = 0
	
	# add one pixel to right and bottom black bars, when we have odd number sized window
	VisualServer.black_bars_set_margins(
		black_bars.x, 
		black_bars.y, 
		black_bars.x + odd_pixel.x, 
		black_bars.y + odd_pixel.y
	)
