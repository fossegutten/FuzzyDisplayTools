tool
extends ViewportContainer
class_name FuzzyViewportContainer


func _init():
	if Engine.editor_hint:
		stretch = true
		mouse_filter = MOUSE_FILTER_IGNORE


func _ready():
	if !Engine.editor_hint:
		FuzzyViewportScaler.connect("viewport_resized", self, "_on_viewport_resized")
		update_size()


func _on_viewport_resized(vp_scale : float):
	update_size()


func update_size() -> void:
	stretch_shrink = FuzzyViewportScaler.viewport_scale
	
