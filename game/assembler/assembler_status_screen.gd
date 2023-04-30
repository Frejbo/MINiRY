extends SubViewport

@export var item_renderer : SubViewport
@export var progressBar : ProgressBar

func _ready():
	get_parent().texture = get_texture()

func started_producing(item : Globals.items, animationLength : float):
	$ScreenTimeout.stop()
	$processing.show()
	print("starting screen")
	progressBar.value = 0
	$"processing/VBoxContainer/item-icon".texture = item_renderer.get_image(item)
	var tween = get_tree().create_tween()
	tween.tween_property(progressBar, "value", 100, animationLength)
	tween.play()
	await tween.finished
	$ScreenTimeout.start()


func _on_screen_timeout_timeout():
	$processing.hide()
