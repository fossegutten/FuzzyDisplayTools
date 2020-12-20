tool
extends EditorPlugin

const SCALE_MODE_SETTING := "display/fuzzy_display_tools/scale_mode"
const PIXEL_PERFECT_SETTING := "display/fuzzy_display_tools/pixel_perfect"
const INTEGER_SCALING_SETTING := "display/fuzzy_display_tools/integer_scaling"

const FUZZY_VP_SCALER := "res://addons/fuzzy_display_tools/singletons/FuzzyViewportScaler.gd"


func _enter_tree():
	add_autoload_singleton("FuzzyViewportScaler", FUZZY_VP_SCALER)
	
	# Recommended / required settings
	# TODO Add a readme, remove this, and let the user set these manually?
	
	# Required by the FuzzyViewportScaler
	ProjectSettings.set("display/window/stretch/mode", "viewport")
	ProjectSettings.set("display/window/stretch/aspect", "ignore")
	# Strongly recommended because we get pixel distortions if users don't have integer scaling in the OS (125, 150, 175, 250% scaling etc.)
	ProjectSettings.set("display/window/dpi/allow_hidpi", true)
	print_debug("FuzzyDisplay tools just changed the following in ProjectSettings:" + \
		"window stretch mode, window stretch aspect and allow_hidpi.")
	
	# Add settings under ProjectSettings -> Display -> Fuzzy display tools
	if !ProjectSettings.has_setting(PIXEL_PERFECT_SETTING):
		ProjectSettings.set_setting(PIXEL_PERFECT_SETTING, false)
		ProjectSettings.set_initial_value(PIXEL_PERFECT_SETTING, false)
	
	if !ProjectSettings.has_setting(INTEGER_SCALING_SETTING):
		ProjectSettings.set_setting(INTEGER_SCALING_SETTING, false)
		ProjectSettings.set_initial_value(INTEGER_SCALING_SETTING, false)
	
	if !ProjectSettings.has_setting(SCALE_MODE_SETTING):
		ProjectSettings.set_setting(SCALE_MODE_SETTING, 0)
		ProjectSettings.set_initial_value(SCALE_MODE_SETTING, 0)
		
	var property_info = {
		"name": SCALE_MODE_SETTING,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "stretch,keep_aspect"#,keep_height,keep_width"
	}
	
	ProjectSettings.add_property_info(property_info)


func _exit_tree():
	pass
