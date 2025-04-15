extends GeneralItem
class_name BookItem


var pages: String = "0/0" # E.g. "10/12"
var volumes: int = 0  # number of volumes (PARENT ONLY!)
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
var pages_reread: int = 0  # Number of pages reread
var date_release_started: String  # The day the series starts releasing
var max_pages: int  # If ongoing, the number of episodes that will be released
var release_schedule: int  # The release schedule for this item in unix time. Ex. 1 week
var episodes_rewatched: int = 0  # The amount of episodes rewatched
var children: Array[GeneralItem]


# Update data column in tree view
func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		if len(children) > 0:
			tree_item.set_text(1, "Status: %s | vol: %d | Rating: %.1f/10" % [status, volumes, rating])
		else:
			tree_item.set_text(1, "Status: %s | Pages: %s | Rating: %.1f/10" % [status, pages, rating])

func update():
	if date_release_started:
		var now = Time.get_date_string_from_system()
		var time = Time.get_unix_time_from_datetime_string(now)
		var time_since_release = time - Manager.get_date_unix(date_release_started)
		if status == "ongoing":
			var total_pages = min(time_since_release/release_schedule + 1, max_pages if max_pages else INF)
			pages = pages.split("/")[0] + "/" + str(total_pages)
			#date_modified = time
			update_data()
	elif status == "reading":
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
		"Type": "Book",
		"Status": status,
		"Genres": genres,
		"Icon": icon,
		"Favorite": is_favorite,
		"Rating": rating,
		"Notes": notes,
		"Pages": pages,
		"Volumes": volumes,
		"Pages Reread": pages_reread,
		"Date Started": date_started,
		"Date Ended": date_ended,
		"Date Modified": date_modified,
	}
	if status == "ongoing":
		data.merge({"Date Release Started": date_release_started,
				"Release Schedule": release_schedule,
				"Max Pages": max_pages})
	var child_data = {}
	for child in children:
		child_data.merge({child.index: child.get_data()})
	if child_data:
		data.merge({"Children": child_data})
	return data
