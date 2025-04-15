extends GeneralItem
class_name SeasonItem

var episodes: String = "0/0" # E.g. "10/12"
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
var date_release_started: String  # The day the series starts releasing
var max_episodes: int  # If ongoing, the number of episodes that will be released
var release_schedule: int  # The release schedule for this item in unix time. Ex. 1 week
var episodes_rewatched: int = 0  # The amount of episodes rewatched
var children: Array[GeneralItem]

func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Episodes: %s | Rating: %0.1f/10" % [status, episodes, rating])

func update():
	if date_release_started:
		var now = Time.get_date_string_from_system()
		var time = Time.get_unix_time_from_datetime_string(now)
		var time_since_release = time - Manager.get_date_unix(date_release_started)
		if status == "ongoing":
			var total_episodes = min(time_since_release/release_schedule + 1, max_episodes if max_episodes else INF)
			episodes = episodes.split("/")[0] + "/" + str(total_episodes)
			#date_modified = time
			update_data()
	elif status == "watching":
		var time = Time.get_unix_time_from_system()
		var time_since_last_update = time - date_modified
		if time_since_last_update >= 604800:  # Update from watching to on hold if not modified for a week
			status = "on hold"
			update_data()
	elif status == "on hold":
		var time = Time.get_unix_time_from_system()
		var time_since_last_update = time - date_modified
		if time_since_last_update >= 2629743:  # Update from on hold to dropped if not modified for a month
			status = "dropped"
			update_data()
			
func get_data():
	var data = {
		"Name": item_name,
		"Type": "Season",
		"Status": status,
		"Genres": genres,
		"Icon": icon,
		"Favorite": is_favorite,
		"Episodes": episodes,
		"Rating": rating,
		"Notes": notes,
		"Rewatches": episodes_rewatched,
		"Date Started": date_started,
		"Date Ended": date_ended,
		"Date Modified": date_modified,
		"Auto Track": auto_track
	}
	if status == "ongoing":
		data.merge({"Date Release Started": date_release_started,
				"Release Schedule": release_schedule,
				"Max Episodes": max_episodes})
	var child_data = {}
	for child in children:
		child_data.merge({child.index: child.get_data()})
	if child_data:
		data.merge({"Children": child_data})
	return data
