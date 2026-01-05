extends GeneralItem
class_name MovieItem

var length: int = 0  # Length of the movie in minutes
var rewatched: int = 0  # Amount of times the movie has been rewatched

# Update data column in tree view
func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Length: %dh %dm | Rating: %.1f/10" % [status, int(length/60), length%60, rating])
<<<<<<< HEAD
		if is_favorite:
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR_FILLED))
		else:
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR))


func export():
	var data = {
			"item_name": item_name,
			"type": "movie",
			"status": status,
			"icon": icon,
			"is_favorite": is_favorite,
			"genres": genres,
			"length": length,
			"rating": rating,
			"notes": notes,
			"rewatched": rewatched,
			"date_started": date_started,
			"date_ended": date_ended,
			"date_modified": date_modified,
			"auto_track": auto_track
=======

func get_data():
	var data = {
		"Name": item_name,
		"Type": "Movie",
		"Status": status,
		"Genres": genres,
		"Icon": icon,
		"Favorite": is_favorite,
		"Rating": rating,
		"Notes": icon,
		"Length": length,
		"Rewatches": rewatched,
		"Date Started": date_started,
		"Date Modified": date_ended,
		"Auto Track": auto_track
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
	}
	return data
