extends Control

@export var scene_path:String
@export var progress_bar:ProgressBar
var progress = []
var scene_load_status = 0

func _ready(): set_process(false)

func load_game():
	ResourceLoader.load_threaded_request(scene_path)
	$AnimationPlayer.play("tone_in")
	set_process(true)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_bar.value = progress[0] * 100
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
		queue_free()
	elif scene_load_status == ResourceLoader.THREAD_LOAD_FAILED:
		print("Kunde inte ladda in scenen " + scene_path)
