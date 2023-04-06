extends Node

#const DEFAULT_PARTICLE_QUALITY : int = 1
const PATH := "user://settings.cfg"
enum SCALE {low, medium, high}
const READABLE_SCALE := ["LOW", "MEDIUM", "HIGH"] # används för att hämta text till inställningsmenyerna. Inställningar är definerade med en siffra, med hjälp av en lista kan vi då hämta en mer läsbar version av kvaliteten.

var config := ConfigFile.new()

func _ready():
	if config.load("user://settings.cfg") != OK: print("Found no config file, creating new.")
	
	Engine.max_fps = max_fps
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_mode(screen_mode)

var particle_quality : SCALE:
	set(val):
		Settings.config.set_value("PARTICLES", "quality", int(val))
		Settings.config.save(Settings.PATH)
	get:
		return Settings.config.get_value("PARTICLES", "quality", DefaultValues.PARTICLE_QUALITY)
var resolution : Vector2i:
	set(res):
#		ProjectSettings.set_setting("display/window/size/viewport_width", res.x)
#		ProjectSettings.set_setting("display/window/size/viewport_height", res.y)
		
		DisplayServer.window_set_size(res)
		
		Settings.config.set_value("DISPLAY", "resolution",  res)
		Settings.config.save(Settings.PATH)
	get:
		return Settings.config.get_value("DISPLAY", "resolution", DefaultValues.RESOLUTION)
var max_fps : int:
	set(val):
#		ProjectSettings.set_setting("application/run/max_fps", val)
		
		Engine.max_fps = val
		Settings.config.set_value("DISPLAY", "max_fps",  val)
		Settings.config.save(Settings.PATH)
	get:
		return Settings.config.get_value("DISPLAY", "max_fps", DefaultValues.MAX_FPS)
var screen_mode : int:
	set(val):
		Settings.config.set_value("DISPLAY", "screen_mode",  val)
		Settings.config.save(Settings.PATH)
		DisplayServer.window_set_mode(val)
	get:
		return Settings.config.get_value("DISPLAY", "screen_mode", DefaultValues.SCREEN_MODE)
