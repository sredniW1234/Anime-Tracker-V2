extends GeneralItem
class_name BookItem

var current_chapter: int = 0
var total_chapters: int = 0

<<<<<<< HEAD
var release_schedule: int
var date_release_started: String
var max_chapters: int = 0

var chapters_reread: int = 0
var children: Array[GeneralItem] = []
=======
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
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f


func update_data():
	if is_instance_valid(tree_item):
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(
			1,
			"Status: %s | Chapters: %d/%d | Rating: %0.1f/10" % [status, current_chapter, total_chapters, rating]
		)
		if is_favorite:
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR_FILLED))
		else:
<<<<<<< HEAD
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR))


func time_update():
	if date_release_started and status == "ongoing":
		var now = Time.get_date_string_from_system()
		var time_now = Time.get_unix_time_from_datetime_string(now)
		var time_since_release = time_now - Manager.get_date_unix(date_release_started)

		var released_chapters = int(time_since_release / release_schedule) + 1
		total_chapters = min(
			released_chapters,
			max_chapters if max_chapters > 0 else INF
		)
		update_data()

	elif status == "reading":
		var time_now = Time.get_unix_time_from_system()
		if time_now - date_modified >= 604800: # 1 week
			status = "on hold"
			update_data()

	elif status == "on hold":
		var time_now = Time.get_unix_time_from_system()
		if time_now - date_modified >= 2629743: # ~1 month
=======
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
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
			status = "dropped"
			update_data()


<<<<<<< HEAD
func export():
	var data := {
		"item_name": item_name,
		"type": "book",
		"status": status,
		"icon": icon,
		"is_favorite": is_favorite,
		"genres": genres,
		"current_chapter": current_chapter,
		"total_chapters": total_chapters,
		"rating": rating,
		"notes": notes,
		"chapters_reread": chapters_reread,
		"date_started": date_started,
		"date_ended": date_ended,
		"date_modified": date_modified,
		"auto_track": auto_track
	}

	if status == "ongoing":
		data.merge({
			"release_schedule": release_schedule,
			"date_release_started": date_release_started,
			"max_chapters": max_chapters
		})

	var child_data := {}
	for child in children:
		child_data[child.index] = child.export()

	if not child_data.is_empty():
		data["children"] = child_data

=======
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
		"Auto Track": auto_track
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
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	return data
