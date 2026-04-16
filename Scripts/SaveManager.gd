extends Node


var current_settings: ConfigFile


func save(path: String):
	if path:
		var savefile = FileAccess.open(path, FileAccess.WRITE)
		var data = {"list_name": Manager.list_name, "tree": {}}
		for parent in Manager.ordered_list_keys:
			data["tree"][parent.index] = parent.export()
		var data_as_json = JSON.stringify(data, "\t", false)
		savefile.store_string(data_as_json)
		savefile.close()


func default_settings():
	var settings: ConfigFile = ConfigFile.new()
	settings.set_value("defaults", "default_status", "None")
	settings.set_value("defaults", "default_auto_track", true)
	settings.set_value("defaults", "default_release_schedule", "Weekly")
	
	# --- saving ---
	settings.set_value("saving", "default_save_location", OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
	settings.set_value("saving", "default_image_location", OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
	settings.set_value("saving", "autosave", true)
	settings.set_value("saving", "autosave_interval", 300)
	settings.set_value("saving", "save_on_exit_prompt", true)
	settings.set_value("saving", "unsaved_warning_timer", 120)
	
	# --- display ---
	settings.set_value("display", "default_collapse", false)
	settings.set_value("display", "theme_options", "Default")
	return settings


func load_settings():
	# --- defaults ---
	var loaded_settings: ConfigFile = ConfigFile.new()
	var err = loaded_settings.load("user://settings.cfg")  # or wherever you save it
	
	if err != OK:
		return err
	
	current_settings = loaded_settings


func save_settings(settings: ConfigFile):
	settings.save("user://settings.cfg")
	current_settings = settings
