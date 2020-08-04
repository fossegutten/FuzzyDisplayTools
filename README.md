# FuzzyDisplayTools
* Addon for Godot Engine 3.1 and 3.2
* Display tools, mostly for 2D games, especially good for pixel art.
* Includes an improved Camera2D and a convenient singleton with automatic viewport resizing.

## Features:
### FuzzyViewportScaler - Singleton:
* Automatically resizes the main viewport, calculated from base window size in ProjectSettings.
    * Support for stretch, keep aspect and integer scaling.
    * Pixel perfect mode is also possible, for the purist!

### FuzzyCamera2D
* No jittering.
* No 1-frame lag/delay, like default camera ( If used properly ).
* Virtual size support, automatically zooms in to get the specified resolution.

### FuzzyViewportContainer and FuzzyViewport:
* Utility scripts, to automatically resize UI viewport when needed (after FuzzyViewportScaler updates scale).
    * Updates ViewportContainer shrink automatically.

## Initial Setup:
### ProjectSettings required settings:
* "display/window/stretch/mode" = "viewport"
* "display/window/stretch/aspect" = "ignore"

### ProjectSettings recommended settings:
* "display/window/dpi/allow_hidpi" = true
    * Strongly recommended because we get pixel distortions if users don't have integer scaling in the OS (125, 150, 175, 250% scaling etc.).
* "display/window/size/width" = 320 / 640 etc.
* "display/window/size/height" = 180 / 360 etc.
    * Some low resolution with 16/9 aspect ratio values is recommended, for modern monitors.
* "rendering/quality/dynamic_fonts/use_oversampling" = false
    * Removes annoying warnings from the Debugger, when resizing window.


## How to use:
### FuzzyViewportScaler - Singleton:
* Should be added automatically in AutoLoad, when the Addon is activated.
* Customize the custom values in ProjectSettings:
    * "display/fuzzy_display_tools/scale_mode" (enum)
    * "display/fuzzy_display_tools/pixel_perfect" (bool)

### FuzzyCamera2D:
* Using virtual size is strongly recommended. Set it to same values (or 50% / 25% etc.) as window size in ProjectSettings, to get the best results.
    * Especially useful if not using pixel perfect mode.
* Use zoom_f (float) parameter instead of regular zoom (Vector2). Adjusting regular zoom values does nothing.
* Create a camera follow target node, and set from editor or script.
* Put the camera last in the scene tree, because it should process after the follow target node. This fixes the 1 frame lag/delay from default camera.

### FuzzyViewportContainer and FuzzyViewport:
1. Depends on FuzzyViewportScaler singleton!
1. Add a CanvasLayer node to your scene.
1. Add a FuzzyViewportContainer as a child of CanvasLayer.
1. Add a FuzzyViewport as a child of FuzzyViewportContainer.
    1. Strongly recommended to set the size to the same as window size in ProjectSettings.
1. Add an instanced UI scene as a child of FuzzyViewport. This is necessary because you cannot edit a scene inside a custom Viewport.
