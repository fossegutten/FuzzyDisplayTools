extends Node

signal viewport_resized(scale)

## TODO in 4.0: 
#  Check if removing black bars work

## HOWTO:
#  Add to AutoLoad in ProjectSettings (automatic if using the plugin)
#  Set base window size in ProjectSettings -> Window
#  Use stretch mode 'viewport' and aspect 'ignore' in ProjectSettings -> Window
#  asd

onready var viewport = get_viewport()
onready var game_size : Vector2 = Vector2(
		ProjectSettings.get("display/window/size/width"), 
		ProjectSettings.get("display/window/size/height")
)
enum ScaleMode {
#	PIXEL_PERFECT,
	STRETCH,
	KEEP_ASPECT,
	KEEP_HEIGHT,
	KEEP_WIDTH
}
export(ScaleMode) var scale_mode : int = ScaleMode.STRETCH setget set_scale_mode, get_scale_mode
export(bool) var pixel_perfect : bool = false setget set_pixel_perfect, is_pixel_perfect

var viewport_scale : float = 1.0


func _ready():
	get_tree().connect("screen_resized", self, "update_viewport_rect")
	
	if ProjectSettings.has_setting("display/fuzzy_display_tools/pixel_perfect"):
		pixel_perfect = ProjectSettings.get("display/fuzzy_display_tools/pixel_perfect")
	if ProjectSettings.has_setting("display/fuzzy_display_tools/pixel_perfect"):
		print(ProjectSettings.get("display/fuzzy_display_tools/scale_mode"))
		scale_mode = ProjectSettings.get("display/fuzzy_display_tools/scale_mode")
	
	update_viewport_rect()


func set_pixel_perfect(value : bool) -> void:
	pixel_perfect = value
	update_viewport_rect()


func set_scale_mode(value : int) -> void:
	scale_mode = value
	update_viewport_rect()


func is_pixel_perfect() -> bool:
	return pixel_perfect


func get_scale_mode() -> int:
	return scale_mode


func update_viewport_rect() -> void:
	if !is_inside_tree():
		return
	
	var window_size : Vector2 = OS.get_window_size()
	
	if pixel_perfect:
		viewport_scale = 1.0
	else:
		viewport_scale = floor(max(1, min(window_size.x / game_size.x, window_size.y / game_size.y)))
	
	get_viewport().size = viewport_scale * game_size
	
	# see how big the window is compared to the viewport size
	var window_viewport_scale : Vector2 = window_size / viewport.size
	var scale_target : Vector2
	
	match scale_mode:
#		ScaleMode.PIXEL_PERFECT:
#			scale_target = Vector2.ONE * max(1, min(floor(window_viewport_scale.x), floor(window_viewport_scale.y)))
		ScaleMode.STRETCH:
			scale_target = Vector2(max(1, window_viewport_scale.x), max(1, window_viewport_scale.y))
		ScaleMode.KEEP_ASPECT:
			scale_target = Vector2.ONE * max(1, min(window_viewport_scale.x, window_viewport_scale.y))
		ScaleMode.KEEP_HEIGHT:
			scale_target = Vector2.ONE * max(1, min(window_viewport_scale.y, window_viewport_scale.y))
		ScaleMode.KEEP_WIDTH:
			scale_target = Vector2.ONE * max(1, min(window_viewport_scale.x, window_viewport_scale.x))
	
	var target_rect : Rect2 = Rect2()
	# size will be divided by two when calculating position, so snap by two pixels to avoid weird results
	target_rect.size = (viewport.size * scale_target).snapped(Vector2.ONE * 2) 
	# floor window size, so we always go to the top left pixel, instead of jagging back and forth
	target_rect.position = (window_size / 2).floor() - (target_rect.size / 2) 
	
	# attach the viewport to the rect we calculated
	viewport.set_attach_to_screen_rect(target_rect)
	
	# BUG(?) in Godot 3.x
	# because godot doesnt clear the render buffer when resizing the viewport rect, add black bars
	var black_bars : Vector2 = (window_size - target_rect.size) / 2
	var odd_pixel : Vector2 = Vector2(int(window_size.x) % 2, int(window_size.y) % 2)
	
	if window_size.x < viewport.size.x:
		black_bars.x = 0
		odd_pixel.x = 0
	if  window_size.y < viewport.size.y:
		black_bars.y = 0
		odd_pixel.y = 0
	
	# add one pixel to right and bottom black bars, when we have odd number sized window
	VisualServer.black_bars_set_margins(black_bars.x, black_bars.y, black_bars.x + odd_pixel.x, black_bars.y + odd_pixel.y) 
	
	emit_signal("viewport_resized", viewport_scale)
