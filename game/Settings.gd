extends Control

#const DEFAULT_PARTICLE_QUALITY : int = 1
const PATH := "user://settings.cfg"
@export var default_environment : Environment

signal changed

enum TWO_SCALE {worse, bad}
const TWO_READABLE_SCALE := ["Worse", "Bad"]
enum THREE_SCALE {low, medium, high}
const THREE_READABLE_SCALE := ["LOW", "MEDIUM", "HIGH"] # används för att hämta text till inställningsmenyerna. Inställningar är definerade med en siffra, med hjälp av en lista kan vi då hämta en mer läsbar version av kvaliteten.

var config := ConfigFile.new()

func _enter_tree():
	if config.load("user://settings.cfg") != OK: print("Found no config file, creating new.")
	
	Engine.max_fps = max_fps
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_mode(screen_mode)
	
	load("res://default_env.tres").sdfgi_enabled = sdfgi


var particle_quality : THREE_SCALE:
	set(val):
		Settings.config.set_value("PARTICLES", "quality", int(val))
		Settings.config.save(Settings.PATH)
		emit_signal("changed")
	get:
		return Settings.config.get_value("PARTICLES", "quality", DefaultValues.PARTICLE_QUALITY)
var resolution : Vector2i:
	set(res):
#		ProjectSettings.set_setting("display/window/size/viewport_width", res.x)
#		ProjectSettings.set_setting("display/window/size/viewport_height", res.y)
		
		DisplayServer.window_set_size(res)
		DisplayServer.window_set_position(Vector2i(0, 30)) # in case you can't drag the window, since windows UI is weird and allows the toolbar to be above the screen.
		
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
		if val == 0: # windowed
			DisplayServer.window_set_position(Vector2i(50, 50)) # in case you can't drag the window, since windows UI is weird and allows the toolbar to be above the screen.
	get:
		return Settings.config.get_value("DISPLAY", "max_fps", DefaultValues.MAX_FPS)
var screen_mode : int:
	set(val):
		Settings.config.set_value("DISPLAY", "screen_mode",  val)
		Settings.config.save(Settings.PATH)
		DisplayServer.window_set_mode(val)
	get:
		return Settings.config.get_value("DISPLAY", "screen_mode", DefaultValues.SCREEN_MODE)
var lighting_quality : THREE_SCALE:
	set(val):
		Settings.config.set_value("GRAPHICS", "lighting_quality", int(val))
		Settings.config.save(Settings.PATH)
		emit_signal("changed")
	get:
		return Settings.config.get_value("GRAPHICS", "lighting_quality", DefaultValues.LIGHTING_QUALITY)
var sdfgi : bool:
	set(val):
		Settings.config.set_value("GRAPHICS", "SDFGI", val)
		Settings.config.save(Settings.PATH)
#		load("res://default_env.tres").sdfgi_enabled = sdfgi
		emit_signal("changed")
	get:
		return Settings.config.get_value("GRAPHICS", "SDFGI", DefaultValues.SDFGI)


func _on_close_pressed(): hide()
