tool
extends EditorPlugin

const SCALE_MODE_SETTING := "display/fuzzy_display_tools/scale_mode"
const PIXEL_PERFECT_SETTING := "display/fuzzy_display_tools/pixel_perfect"

const FUZZY_VP_SCALER := "res://addons/fuzzy_display_tools/singletons/FuzzyViewportScaler.gd"


func _enter_tree():
	add_autoload_singleton("FuzzyViewportScaler", FUZZY_VP_SCALER)
	
	# Add settings under ProjectSettings -> Display -> Fuzzy display tools
	if !ProjectSettings.has_setting(PIXEL_PERFECT_SETTING):
		ProjectSettings.set_setting(PIXEL_PERFECT_SETTING, false)
		ProjectSettings.set_initial_value(PIXEL_PERFECT_SETTING, false)
	
	if !ProjectSettings.has_setting(SCALE_MODE_SETTING):
		ProjectSettings.set_setting(SCALE_MODE_SETTING, 0)
		ProjectSettings.set_initial_value(SCALE_MODE_SETTING, 0)
		
	var property_info = {
		"name": SCALE_MODE_SETTING,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "stretch,keep_aspect,integer_scaling"
	}
	
	ProjectSettings.add_property_info(property_info)


func _exit_tree():
	pass
