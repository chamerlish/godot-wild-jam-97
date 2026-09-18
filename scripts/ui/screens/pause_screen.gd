extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			hide()
		else:
			show()
		get_tree().paused = !get_tree().paused


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
