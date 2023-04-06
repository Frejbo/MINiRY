extends Node

#const DEFAULT_PARTICLE_QUALITY : int = 1
const PATH := "user://settings.cfg"
enum SCALE {low, medium, high}
const READABLE_SCALE := ["LOW", "MEDIUM", "HIGH"] # används för att hämta text till inställningsmenyerna. Inställningar är definerade med en siffra, med hjälp av en lista kan vi då hämta en mer läsbar version av kvaliteten.

var config := ConfigFile.new()
@onready var loaded_config := config.load("user://settings.cfg") == OK # loaded_configs is true or false. true if configs found and loaded.

func _ready():
	DisplayServer.window_set_size(resolution)

var particle_quality : SCALE:
	set(val):
		Settings.config.set_value("PARTICLES", "quality", int(val))
		Settings.config.save(Settings.PATH)
	get:
		return Settings.config.get_value("PARTICLES", "quality", DefaultValues.PARTICLE_QUALITY)

var resolution : Vector2i:
	set(res):
		ProjectSettings.set_setting("display/window/size/viewport_width", res.x)
		ProjectSettings.set_setting("display/window/size/viewport_height", res.y)
		
		DisplayServer.window_set_size(res)
		
		Settings.config.set_value("DISPLAY", "resolution",  res)
		Settings.config.save(Settings.PATH)
	get:
		return Settings.config.get_value("DISPLAY", "resolution", DefaultValues.RESOLUTION)
