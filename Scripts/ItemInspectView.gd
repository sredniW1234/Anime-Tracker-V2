extends Control

var item: GeneralItem = null
var episodes: float = 0
var total_episodes: float = 0
var selected_genres: Array[String] = []

#region Row 1
@onready var season_name: LineEdit = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/SeasonName
@onready var rating_slider: HSlider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingSlider
@onready var rating_label: Label = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingLabel
@onready var rewatch_spinbox: SpinBox = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RewatchSpinbox
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
@onready var genres_panel: Panel = $MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/GenrePanelContainer/MarginContainer/Panel
@onready var possible_genres: HFlowContainer = $"MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/GenrePanelContainer/MarginContainer/Panel/VBoxContainer/ScrollContainer/Possible Genres"
@onready var genre_flow_container: FlowContainer = $MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/GenrePanelContainer/MarginContainer/ScrollContainer/GenreFlowContainer
var genre_option = preload("res://Scenes/genre_button.tscn")
#endregion

#region Row 4
@onready var auto_track_toggle: CheckBox = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/AutoTrackToggle
<<<<<<< HEAD
@onready var date_started: Button = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/DateStarted
@onready var date_ended: Button = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/DateEnded
@onready var spacer_3: MarginContainer = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Spacer3
@onready var release_schedule_option: OptionButton = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/ReleaseScheduleOption
@onready var release_started: Button = $"MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Release Started"
@onready var release_count: SpinBox = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/ReleaseCount
=======
@onready var date_started: Button = $"MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Date Started"
@onready var date_ended: Button = $"MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Date Ended"
@onready var spacer_3: MarginContainer = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Spacer3
@onready var release_schedule_option: OptionButton = $MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/ReleaseScheduleOption
@onready var release_started: Button = $"MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Release Started"
@onready var episode_count: SpinBox = $"MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Dates/Episode Count"
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
#endregion


func _ready() -> void:
	Manager.connect("selected_changed", load_view)
	date_started.connect("date_selected", start_date_selected)
	date_ended.connect("date_selected", end_date_selected)


# Grab the selected genres and set the item's genre
func set_genres():
	selected_genres = []
	
	# Clear all children
	for child in genre_flow_container.get_children().slice(1):
		child.queue_free()
	
	# Go through each pressed button and add it to the list
	for genre_button in possible_genres.get_children():
		if genre_button.button_pressed:
			selected_genres.append(genre_button.text)
			var dupe_genre_button = genre_button.duplicate()
			dupe_genre_button.button_pressed = false
			dupe_genre_button.disabled = true
			genre_flow_container.add_child(dupe_genre_button)
	item.genres = selected_genres


# Load possible genres into the genre container
func load_genres():
	var genre_list
	
	# Clear all children
	for child in genre_flow_container.get_children().slice(1) + possible_genres.get_children():
		child.queue_free()
	
	season_name.placeholder_text = "Name Goes Here"
	
	# Get the genre list
	if is_instance_of(item, SeasonItem):
		genre_list = Manager.POSSIBLE_SEASON_GENRES
	elif is_instance_of(item, MovieItem):
		genre_list = Manager.POSSIBLE_MOVIE_GENRES
	elif is_instance_of(item, BookItem):
		genre_list = Manager.POSSIBLE_BOOK_GENRES
		
	# Add each genre to the selction genre list
	for genre in genre_list:
		var genre_button = genre_option.instantiate()
		genre_button.text = genre
		# Check if the genre is already selected
		if genre in item.genres:
			genre_button.button_pressed = true
			# Make a duplicate and put it in the genre flow container
			var dupe_genre_button = genre_button.duplicate()
			dupe_genre_button.button_pressed = false
			dupe_genre_button.disabled = true
			genre_flow_container.add_child(dupe_genre_button)
		possible_genres.add_child(genre_button)


# Load the insepct view
func load_view(current_item: GeneralItem):
	item = current_item
	item.update_data()
	season_name.text = item.item_name
	rating_slider.value = item.rating
	rating_slider.emit_signal("value_changed", rating_slider.value)
	
	watch_divider.show()
	total_watch.show()
	release_schedule_option.hide()
	release_started.hide()
	release_count.hide()
	spacer_3.hide()
	genres_panel.hide()
<<<<<<< HEAD
	status_dropdown.clear()
=======
	release_started.hide()
	episode_count.hide()
	date_started.select_date(item.date_started)
	date_ended.select_date(item.date_ended)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	
	auto_track_toggle.button_pressed = item.auto_track
	date_started.text = item.date_started
	date_ended.text = item.date_ended
	release_schedule_option.select(-1)
	notes.text = item.notes
	load_genres()
	#set_genres()
	
	# Item type dependant changes
	if is_instance_of(item, MovieItem):
		media_length.text = "Movie Length (m): "
		watch_divider.hide()
		total_watch.hide()
		current_watch.value = item.length
		rewatch_spinbox.value = item.rewatched
		
		for status in Manager.POSSIBLE_MOVIE_STATUS:
			status_dropdown.add_item("Status: " + status.capitalize())
		status_dropdown.select(Manager.POSSIBLE_MOVIE_STATUS.find(item.status))
		
	elif is_instance_of(item, SeasonItem):
		media_length.text = "Episodes: "
		episodes = item.current_episode  # Get the current episode count
		total_episodes = item.total_episodes  # Get the total episode count
		current_watch.value = episodes
		total_watch.value = total_episodes
		progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1.0)
		progress_bar.value *= 100  # Convert decimal to percentage
		rewatch_spinbox.value = item.episodes_rewatched
		release_started.select_date(item.date_release_started)
		release_schedule_option.select(Manager.SCHEDULE_TO_UNIX.values().find(item.release_schedule))  # Get the index of release schedule index and select that option
		
		for status in Manager.POSSIBLE_SEASON_STATUS:
			status_dropdown.add_item("Status: " + status.capitalize())
		status_dropdown.select(Manager.POSSIBLE_SEASON_STATUS.find(item.status))
		
		if item.status == "ongoing":
			release_schedule_option.show()
			spacer_3.show()
			release_started.show()
<<<<<<< HEAD
			release_count.show()
			print("here")
=======
			episode_count.show()
		elif episodes >= total_episodes:
			status_dropdown.select(0)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	elif is_instance_of(item, BookItem):
		media_length.text = "Pages: "
		var pages = int(item.pages.split("/")[0])  # Get the current episode count
		var total_pages = int(item.pages.split("/")[1])  # Get the total episode count
		current_watch.value = pages
		total_watch.value = total_pages
		progress_bar.value = pages/(total_pages if total_pages != 0.0 else 1.0)
		progress_bar.value *= 100  # Convert decimal to percentage
		rewatch_spinbox.value = item.pages_reread
		
		for status in Manager.POSSIBLE_BOOK_STATUS:
			status_dropdown.add_item("Status: " + status.capitalize())
		status_dropdown.select(Manager.POSSIBLE_BOOK_STATUS.find(item.status))


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
	# Set the value depending on item type
	if is_instance_of(item, SeasonItem):
		episodes = value
<<<<<<< HEAD
		#item.episodes = str(episodes) + "/" + str(total_episodes)
		item.current_episode = episodes
=======
		item.episodes = str(episodes) + "/" + str(total_episodes)
		if episodes >= total_episodes:
			status_dropdown.select(0)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
		item.update_data()
	elif is_instance_of(item, MovieItem):
		item.length = value
		item.update_data()
		
	progress_bar.value = episodes/(total_episodes if total_episodes != 0 else 1.0)
	progress_bar.value *= 100


func _on_total_watch_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		total_episodes = value
<<<<<<< HEAD
		#item.episodes = str(episodes) + "/" + str(total_episodes)
		item.total_episodes = total_episodes
=======
		item.episodes = str(episodes) + "/" + str(total_episodes)
		if episodes >= total_episodes:
			status_dropdown.select(0)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
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
		release_started.show()
<<<<<<< HEAD
		release_count.show()
=======
		episode_count.show()
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	else:
		release_schedule_option.hide()
		spacer_3.hide()
		release_started.hide()
<<<<<<< HEAD
		release_count.hide()
=======
		episode_count.hide()
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	if item:
		item.date_modified = Time.get_unix_time_from_system()


# Get Schedule in unix time
func _on_release_schedule_option_item_selected(index: int) -> void:
	if item:
		var schedule = release_schedule_option.get_item_text(index).split(": ")[1]
		item.release_schedule = Manager.SCHEDULE_TO_UNIX[schedule.to_lower()]

# Add genres
func _on_add_genres_pressed() -> void:
	set_genres()
	genres_panel.hide()

# Show Genre Panel
func _on_show_genres_pressed() -> void:
	genres_panel.show()

<<<<<<< HEAD

func start_date_selected(date, _unix):
	if item:
		item.date_started = date


func end_date_selected(date, _unix):
	if item:
		item.date_ended = date


func _on_rewatch_spinbox_value_changed(value: float) -> void:
	if item:
		if is_instance_of(item, BookItem):
			item.pages_reread = value
		elif is_instance_of(item, MovieItem):
			item.rewatched = value
		elif is_instance_of(item, SeasonItem):
			item.episodes_rewatched = value


func _on_release_count_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		item.max_episodes = value


func _on_release_started_date_selected(date: Variant, unix: Variant) -> void:
	if is_instance_of(item, SeasonItem):
		item.date_release_started = date


func _on_favorite_toggle_toggled(toggled_on: bool) -> void:
	if item:
		item.is_favorite = toggled_on
=======
# Change the Item start date
func _on_date_started_date_selected(date: String) -> void:
	if item:
		item.date_started = date

# Change the Item end date
func _on_date_ended_date_selected(date: String) -> void:
	if item:
		item.date_started = date

# Change the Item rellease started date
func _on_release_started_date_selected(date: String) -> void:
	if is_instance_of(item, SeasonItem):
		item.date_release_started = date

# If ongoing, change the maximum episode/chapter count
func _on_episode_count_value_changed(value: float) -> void:
	if is_instance_of(item, SeasonItem):
		item.max_episodes = value
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
