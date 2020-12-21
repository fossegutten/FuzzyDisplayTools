extends Control

# Do not run this scene directly. It should be instanced inside:
# res://addons/fuzzy_display_tools/example_scene/FuzzyDisplayToolsExample.tscn 

func _ready():
	$VBoxContainer/PixelPerfectButton.pressed = FuzzyViewportScaler.pixel_perfect
	$VBoxContainer/IntegerScalingButton.pressed = FuzzyViewportScaler.integer_scaling
	$VBoxContainer/ScaleModeOptionButton.selected = FuzzyViewportScaler.get_scale_mode()


func _process(delta):
	var l : Label = $Label
	
	l.text = "Base resolution: %s" % [FuzzyViewportScaler.game_size]
	l.text += "\nMain Viewport res: %s" % [$"/root".get_viewport().size]
	l.text += "\nMain Viewport scale: %s" % [FuzzyViewportScaler.viewport_scale]
	l.text += "\nPixel perfect: %s" % [FuzzyViewportScaler.pixel_perfect]
	l.text += "\nInteger scaling: %s" % [FuzzyViewportScaler.integer_scaling]
	l.text += "\nP1 controls: Arrow keys"
	l.text += "\nP2 controls: WASD"


func _on_FullscreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_PixelPerfectButton_toggled(button_pressed):
	FuzzyViewportScaler.set_pixel_perfect(button_pressed)


func _on_ScaleModeOptionButton_item_selected(index):
	FuzzyViewportScaler.set_scale_mode(index)


func _on_IntegerScalingButton_toggled(button_pressed):
	FuzzyViewportScaler.set_integer_scaling(button_pressed)


func _on_AspectRatioButton_item_selected(index):
	var text : String = $VBoxContainer/AspectRatioButton.get_item_text(index)
	var size := Vector2.ZERO
	
	if text == "16/9":
		size = Vector2(640,360)
	if text == "21/9":
		size = Vector2(860, 360)
	if text == "4/3":
		size = Vector2(480, 360)
	if text == "16/10":
		size = Vector2(576, 360)
	
	if !size.is_equal_approx(Vector2.ZERO):
		FuzzyViewportScaler.game_size = size
		FuzzyViewportScaler.update_viewport_rect()
	else:
		printerr("Could not update resolution to: %s" % size)
