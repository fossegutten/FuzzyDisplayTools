tool
extends ViewportContainer
class_name FuzzyViewportContainer

## Warning!
#  Depends on FuzzyViewportScaler singleton

## HOWTO:
#  For UI / Control nodes. To have a fixed size UI.
#  Updates shrink automatically, after FuzzyViewportScaler updates


onready var game_size : Vector2 = Vector2(
		ProjectSettings.get("display/window/size/width"), 
		ProjectSettings.get("display/window/size/height")
)
#onready var viewport_ui : Viewport = $VP


func _ready():
	FuzzyViewportScaler.connect("viewport_resized", self, "_on_viewport_resized")
	update_size()


func _on_viewport_resized(vp_scale : float):
	update_size()


func update_size() -> void:
	stretch_shrink = FuzzyViewportScaler.viewport_scale
	
