extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	hide()


func _notification(what):
	# Intercept the quit request
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Manager.made_changes and SaveManager.current_settings.get_value("saving", "save_on_exit_prompt", false):
			show()
		else:
			get_tree().quit()


func _on_no_pressed() -> void:
	hide()


func _on_yes_pressed() -> void:
	get_tree().quit()
