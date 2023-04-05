extends Node

#const DEFAULT_PARTICLE_QUALITY : int = 1
const PATH := "user://settings.cfg"
enum SCALE {low, medium, high}
const READABLE_SCALE := ["LOW", "MEDIUM", "HIGH"] # används för att hämta text till inställningsmenyerna. Inställningar är definerade med en siffra, med hjälp av en lista kan vi då hämta en mer läsbar version av kvaliteten.

var config := ConfigFile.new()
@onready var loaded_config := config.load("user://settings.cfg") == OK # loaded_configs is true or false. true if configs found and loaded.


var particle_quality:
	set(val):
		Settings.config.set_value("PARTICLES", "quality", int(val))
		Settings.config.save(Settings.PATH)
	get:
		if !Settings.loaded_config: return DefaultValues.PARTICLE_QUALITY
		return Settings.config.get_value("PARTICLES", "quality")
#var window_width:
#	set(val):
#		Settings.config.set_value("DISPLAY", "width",  val)
#		Settings.config.save(Settings.PATH)
#	get:
#		if !Settings.loaded_config: return DefaultValues.PARTICLE_QUALITY
#		return Settings.config.get_value("DISPLAY", "widht")
#var window_height:
#	set(val):
#		Settings.config.set_value("DISPLAY", "height",  val)
#		Settings.config.save(Settings.PATH)
#	get:
#		if !Settings.loaded_config: return DefaultValues.PARTICLE_QUALITY
#		return Settings.config.get_value("DISPLAY", "height")
