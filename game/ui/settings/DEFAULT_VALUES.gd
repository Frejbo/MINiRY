extends Node

# particles
const PARTICLE_QUALITY : int = 1

# display
var RESOLUTION : Vector2i = Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
var MAX_FPS : int = ProjectSettings.get_setting("application/run/max_fps")
const SCREEN_MODE := DisplayServer.WINDOW_MODE_WINDOWED

# graphics
const LIGHTING_QUALITY := Settings.TWO_SCALE.bad
const SDFGI := true
