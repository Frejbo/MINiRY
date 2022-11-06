extends Node3D


func _ready():
	# set screen viewports textures, buggat och ger error om gjort via editorn...
#	$map/Screen/SubViewport/AspectRatioContainer/TextureRect.texture = $Anka.get_texture()
	$map/Screen/Sprite3D.texture = $map/Screen/level0.get_texture()
	pass
