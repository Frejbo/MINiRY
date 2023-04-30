extends SubViewport

@export var item_renderer : SubViewport
@export var progressBar : ProgressBar

func started_producing(item : Globals.items, length : float):
	progressBar.value = 0
	$processing/VBoxContainer/TextureRect.texture = item_renderer.get_image(item)
	var tween = progressBar.create_tween()
	tween.tween_property(progressBar, "value", 100, length)
	tween.play()
	await tween.finished
	
