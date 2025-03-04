extends Control

var item: GeneralItem = null
var episodes: float = 0
var total_episodes: float = 0

#region Row 1
@onready var season_name: LineEdit = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/SeasonName
@onready var rating_slider: HSlider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingSlider
@onready var rating_label: Label = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingLabel
#endregion

#region Row 2

@onready var media_length: Label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/Length
@onready var current_watch: SpinBox = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/CurrentWatch
@onready var watch_divider: Label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/WatchDivider
@onready var total_watch: SpinBox = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/TotalWatch
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/ProgressBar
@onready var status_dropdown: OptionButton = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/StatusDropdown
#endregion

#region Row 3
@onready var notes: TextEdit = $MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/Notes
#endregion

#region Row 4
@onready var auto_track_toggle: CheckBox = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/AutoTrackToggle
@onready var spacer_3: MarginContainer = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Spacer3
@onready var release_schedule_option: OptionButton = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/ReleaseScheduleOption
#endregion


func _ready() -> void:
	Manager.connect("selected_changed", load_view)


func load_view(current_item: GeneralItem):
	item = current_item
	item.update_data()
	season_name.text = item.item_name
	rating_slider.value = item.rating
	rating_slider.emit_signal("value_changed", rating_slider.value)
	
	watch_divider.show()
	total_watch.show()
	release_schedule_option.hide()
	spacer_3.hide()
	status_dropdown.clear()
	
	auto_track_toggle.button_pressed = item.auto_track
	release_schedule_option.select(-1)
	
	# Item type dependant changes
	if is_instance_of(item, MovieItem):
		media_length.text = "Movie Length (m): "
		watch_divider.hide()
		total_watch.hide()
		current_watch.value = item.length
		for status in Manager.POSSIBLE_MOVIE_STATUS:
			status_dropdown.add_item("Status: " + status.capitalize())
		status_dropdown.select(Manager.POSSIBLE_MOVIE_STATUS.find(item.status))
	elif is_instance_of(item, SeasonItem):
		media_length.text = "Episodes: "
		episodes = int(item.episodes.split("/")[0])  # Get the current episode count
		total_episodes = int(item.episodes.split("/")[1])  # Get the total episode count
		current_watch.value = episodes
		total_watch.value = total_episodes
		progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1.0)
		progress_bar.value *= 100  # Convert decimal to percentage
		for status in Manager.POSSIBLE_SEASON_STATUS:
			status_dropdown.add_item("Status: " + status.capitalize())
		status_dropdown.select(Manager.POSSIBLE_SEASON_STATUS.find(item.status))
		if item.status == "ongoing":
			release_schedule_option.show()
			spacer_3.show()


func _on_rating_slider_value_changed(value: float) -> void:
	# E.g. 0.0 instead of 0
	rating_label.text = "Rating: %s/10" % (str(value) + (".0" if int(value) == value else ""))
	if item:
		item.rating = value
		item.update_data()


func _on_season_name_text_changed(new_text: String) -> void:
	if item:
		item.item_name = new_text


func _on_current_watch_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		episodes = value
		item.episodes = str(episodes) + "/" + str(total_episodes)
		item.update_data()
	elif is_instance_of(item, MovieItem):
		item.length = value
		item.update_data()
	progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1.0)
	progress_bar.value *= 100


func _on_total_watch_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		total_episodes = value
		item.episodes = str(episodes) + "/" + str(total_episodes)
		item.update_data()
	progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1.0)
	progress_bar.value *= 100

func _on_text_edit_text_changed() -> void:
	if item:
		item.notes = notes.text


func _on_auto_track_toggle_toggled(toggled_on: bool) -> void:
	if item:
		item.auto_track = toggled_on


func _on_status_dropdown_item_selected(index: int) -> void:
	if is_instance_of(item, SeasonItem):
		item.status = Manager.POSSIBLE_SEASON_STATUS[index]
		item.update_data()
	elif is_instance_of(item, MovieItem):
		item.status = Manager.POSSIBLE_MOVIE_STATUS[index]
		item.update_data()
	elif is_instance_of(item, BookItem):
		item.status = Manager.POSSIBLE_BOOK_STATUS[index]
		item.update_data()
	if item and item.status == "ongoing":
		release_schedule_option.show()
		spacer_3.show()
	else:
		release_schedule_option.hide()
		spacer_3.hide()


func _on_release_schedule_option_item_selected(index: int) -> void:
	if item:
		var schedule = release_schedule_option.get_item_text(index).split(": ")[1]
		item.release_schedule = Manager.SCHEDULE_TO_UNIX[schedule.to_lower()]
