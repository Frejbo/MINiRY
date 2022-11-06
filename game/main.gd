extends Node3D


func _ready():
	# set screen viewports textures, buggat och ger error om gjort via editorn...
#	$map/Screen/SubViewport/AspectRatioContainer/TextureRect.texture = $Anka.get_texture()
	var screen = load("res://levels/level_" + Globals.current_level + ".tscn").instantiate()
	add_child(screen)
	$map/Screen/Sprite3D.texture = screen.get_node("level").get_texture()
	pass
