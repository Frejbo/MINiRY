extends CenterContainer

var paused = false

func _input(event):
	if not event.is_action_pressed("paus"): return
	switch_pause_mode()

func switch_pause_mode():
	if paused:
		hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		paused = false
	else:
		show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		self.paused = false
		paused = true

func _on_avsluta_pressed():
	switch_pause_mode()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_packed(load("res://main_menu.tscn"))

func _on_fortstt_pressed():
	switch_pause_mode()
