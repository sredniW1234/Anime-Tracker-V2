extends Control


@onready var defaults_button: Button = $HBoxContainer/Tab/MarginContainer/VBoxContainer/Defaults
@onready var saving_button: Button = $HBoxContainer/Tab/MarginContainer/VBoxContainer/Saving
@onready var display_button: Button = $HBoxContainer/Tab/MarginContainer/VBoxContainer/Display

# --- DEFAULT OPTIONS ---
@onready var defaults_tab: VBoxContainer = $HBoxContainer/Setting/MarginContainer/Defaults
@onready var default_status: OptionButton = $HBoxContainer/Setting/MarginContainer/Defaults/DefaultStatus
@onready var auto_track: CheckButton = $HBoxContainer/Setting/MarginContainer/Defaults/AutoTrack
@onready var default_schedule: OptionButton = $HBoxContainer/Setting/MarginContainer/Defaults/DefaultSchedule

# --- SAVING OPTIONS ---
@onready var saving_tab: VBoxContainer = $HBoxContainer/Setting/MarginContainer/Saving
@onready var default_save_file_location: LineEdit = $"HBoxContainer/Setting/MarginContainer/Saving/HBoxContainer/Default Save File Location"
@onready var default_image_location: LineEdit = $"HBoxContainer/Setting/MarginContainer/Saving/HBoxContainer3/Default Image Location"
@onready var auto_save: CheckButton = $HBoxContainer/Setting/MarginContainer/Saving/AutoSave
@onready var autosave_freq: SpinBox = $HBoxContainer/Setting/MarginContainer/Saving/HBoxContainer4/autosave_freq
@onready var soe_prompt: CheckButton = $"HBoxContainer/Setting/MarginContainer/Saving/SOE Prompt"
@onready var warn_freq: SpinBox = $HBoxContainer/Setting/MarginContainer/Saving/HBoxContainer2/warn_freq

# --- DISPLAY OPTIONS ---
@onready var display_tab: VBoxContainer = $HBoxContainer/Setting/MarginContainer/Display
@onready var load_tree_collapsed: CheckButton = $"HBoxContainer/Setting/MarginContainer/Display/Load Tree Collapsed"
@onready var theme_options: OptionButton = $HBoxContainer/Setting/MarginContainer/Display/ThemeOptions

var DEFAULT_OPTIONS = {
	# Defaults
	"default_status": "watching",
	"default_auto_track": true,
	"default_release_schedule": "weekly",
	
	# Saving
	"default_save_location": OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP),
	"default_image_location": OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP),
	"autosave": false,
	"autosave_interval": 300,
	"save_on_exit_prompt": true,
	"unsaved_warning_timer": 120,
	
	# Display
	"default_collapse": false,
	"theme_options": "default"
}
var settings: ConfigFile = ConfigFile.new()

func _ready() -> void:
	default_save_file_location.text = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	default_image_location.text = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	load_settings()
	#save()

func set_settings(_args=0):
	# --- defaults ---
	var status = default_status.get_item_text(default_status.get_selected_id())
	settings.set_value("defaults", "default_status", status.split(": ")[1])
	settings.set_value("defaults", "default_auto_track", auto_track.button_pressed)
	var schedule = default_schedule.get_item_text(default_schedule.get_selected_id())
	settings.set_value("defaults", "default_release_schedule", schedule.split(": ")[1])
	
	# --- saving ---
	settings.set_value("saving", "default_save_location", default_save_file_location.text)
	settings.set_value("saving", "default_image_location", default_image_location.text)
	settings.set_value("saving", "autosave", auto_save.button_pressed)
	settings.set_value("saving", "autosave_interval", autosave_freq.value)
	settings.set_value("saving", "save_on_exit_prompt", soe_prompt.button_pressed)
	settings.set_value("saving", "unsaved_warning_timer", warn_freq.value)
	
	# --- display ---
	settings.set_value("display", "default_collapse", load_tree_collapsed.button_pressed)
	var curr_theme = theme_options.get_item_text(theme_options.get_selected_id())
	settings.set_value("display", "theme_options", curr_theme.split(": ")[1])
	
	return settings


func load_settings():
	# --- defaults ---
	var err = SaveManager.load_settings()
	if err != OK:
		settings = SaveManager.default_settings()
	else:
		settings = err
	
	var status = settings.get_value("defaults", "default_status", "")
	for i in default_status.item_count:
		if default_status.get_item_text(i).ends_with(status):
			default_status.select(i)
			break
	auto_track.button_pressed = settings.get_value("defaults", "default_auto_track", false)
	var schedule = settings.get_value("defaults", "default_release_schedule", "")
	for i in default_schedule.item_count:
		if default_schedule.get_item_text(i).ends_with(schedule):
			default_schedule.select(i)
			break

	# --- saving ---
	default_save_file_location.text = settings.get_value("saving", "default_save_location", "")
	default_image_location.text = settings.get_value("saving", "default_image_location", "")
	auto_save.button_pressed = settings.get_value("saving", "autosave", false)
	autosave_freq.value = settings.get_value("saving", "autosave_interval", 5)
	soe_prompt.button_pressed = settings.get_value("saving", "save_on_exit_prompt", false)
	warn_freq.value = settings.get_value("saving", "unsaved_warning_timer", 60)

	# --- display ---
	load_tree_collapsed.button_pressed = settings.get_value("display", "default_collapse", false)
	var selected_theme = settings.get_value("display", "theme_options", "")
	for i in theme_options.item_count:
		if theme_options.get_item_text(i).ends_with(selected_theme):
			theme_options.select(i)
			break

func save():
	set_settings()
	SaveManager.save_settings(settings)

#region Tabbing Logic

func _on_defaults_pressed() -> void:
	defaults_tab.show()
	saving_tab.hide()
	display_tab.hide()
	saving_button.button_pressed = false
	display_button.button_pressed = false

func _on_saving_pressed() -> void:
	defaults_tab.hide()
	saving_tab.show()
	display_tab.hide()
	defaults_button.button_pressed = false
	display_button.button_pressed = false

func _on_display_pressed() -> void:
	defaults_tab.hide()
	saving_tab.hide()
	display_tab.show()
	defaults_button.button_pressed = false
	saving_button.button_pressed = false
#endregion
