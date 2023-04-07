extends CenterContainer


func _input(event):
	if not event.is_action_pressed("paus"): return
	if $Settings.visible: # om settings är öppet, stäng settings men byt inte fortsätt inte spelet.
		$Settings.hide()
		return
	switch_pause_mode()

func switch_pause_mode():
	if get_tree().paused:
		hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#		self.paused = false

func _on_avsluta_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_fortstt_pressed():
	switch_pause_mode()


func _on_settings_pressed():
	$Settings.show()
