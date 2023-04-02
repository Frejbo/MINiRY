@tool
extends MeshInstance3D

func _process(delta):
	self.set_shader_param("object_to_world", transform)
