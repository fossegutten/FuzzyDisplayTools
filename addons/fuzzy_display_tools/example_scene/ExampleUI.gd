extends Control

# Do not run this scene directly. It should be instanced inside:
# res://addons/fuzzy_display_tools/example_scene/FuzzyDisplayToolsExample.tscn 

func _process(delta):
	var l : Label = $Label
	
	l.text = "VP scale: %s" % [FuzzyViewportScaler.viewport_scale]
	l.text += "\nVP res: %s" % [$"/root".get_viewport().size]
	

func _on_Button_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
