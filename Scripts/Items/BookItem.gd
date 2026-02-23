extends GeneralItem
class_name BookItem

var current_chapter: int = 0
var total_chapters: int = 0

var release_schedule: int
var date_release_started: String
var max_chapters: int = 0

var chapters_reread: int = 0
var children: Array[GeneralItem] = []


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
			status = "dropped"
			update_data()


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

	return data
