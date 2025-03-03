extends Control

var item: GeneralItem = null
var episodes: float = 0
var total_episodes: float = 0

@onready var season_name: LineEdit = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/SeasonName
@onready var rating_slider: HSlider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingSlider
@onready var rating_label: Label = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingLabel

@onready var media_length: Label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/Length
@onready var current_watch: SpinBox = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/CurrentWatch
@onready var watch_divider: Label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/WatchDivider
@onready var total_watch: SpinBox = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/TotalWatch
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/ProgressBar
@onready var status_dropdown: OptionButton = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/StatusDropdown

@onready var notes: TextEdit = $MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/Notes

@onready var auto_track_toggle: CheckBox = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/AutoTrackToggle


func _ready() -> void:
	Manager.connect("selected_changed", load_view)


func load_view(current_item: GeneralItem):
	item = current_item
	season_name.text = item.item_name
	rating_slider.value = item.rating
	rating_slider.emit_signal("value_changed", rating_slider.value)
	
	watch_divider.show()
	total_watch.show()
	
	status_dropdown.clear()
	for status in item.POSSIBLE_STATUS:
		status_dropdown.add_item("Status: " + status.capitalize())
	
	auto_track_toggle.button_pressed = item.auto_track
	
	# Item type dependant changes
	if is_instance_of(item, MovieItem):
		media_length.text = "Movie Length (m): "
		watch_divider.hide()
		total_watch.hide()
		current_watch.value = item.length
	elif is_instance_of(item, SeasonItem):
		media_length.text = "Episodes: "
		episodes = int(item.episodes.split("/")[0])  # Get the current episode count
		total_episodes = int(item.episodes.split("/")[1])  # Get the total episode count
		current_watch.value = episodes
		total_watch.value = total_episodes
		progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1)
		progress_bar.value *= 100
	


func _on_rating_slider_value_changed(value: float) -> void:
	rating_label.text = "Rating: %s/10" % (str(value) + (".0" if int(value) == value else ""))
	if item:
		item.rating = value


func _on_season_name_text_changed(new_text: String) -> void:
	if item:
		item.item_name = new_text


func _on_current_watch_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		episodes = value
		item.episodes = str(episodes) + "/" + str(total_episodes)
	elif is_instance_of(item, MovieItem):
		item.length = value
	progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1)
	progress_bar.value *= 100


func _on_total_watch_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		total_episodes = value
		item.episodes = str(episodes) + "/" + str(total_episodes)
	progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1)
	progress_bar.value *= 100


func _on_text_edit_text_changed() -> void:
	if item:
		item.notes = notes.text


func _on_auto_track_toggle_toggled(toggled_on: bool) -> void:
	if item:
		item.auto_track = toggled_on
