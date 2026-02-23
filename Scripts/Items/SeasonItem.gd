extends GeneralItem
class_name SeasonItem

var current_episode: int = 0 
var total_episodes: int = 0
var release_schedule: int  # The release schedule for this item in unix time
var date_release_started: String # Date the item ended releasing (Ongoing)
var max_episodes = 0
var episodes_rewatched: int = 0  # The amount of episodes rewatched
var children: Array[GeneralItem]

func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Episodes: %d/%d | Rating: %0.1f/10" % [status, current_episode, total_episodes, rating])
		if is_favorite:
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR_FILLED))
		else:
			tree_item.set_icon(2, ImageTexture.create_from_image(STAR))
		
		# Update parent
		if not is_level_1():
			Manager.ordered_list_keys[parent.get_index()].update_data()
		
		# Auto populate episodes if children
		if len(children) > 0:
			var episodes = 0
			var total = 0
			for child in children:
				if is_instance_of(child, SeasonItem):
					episodes += child.current_episode
					total += child.total_episodes
				if Manager.POSSIBLE_SEASON_STATUS.find(child.status) >= Manager.POSSIBLE_SEASON_STATUS.find(status):
					status = child.status
			current_episode = episodes
			total_episodes = total


func time_update():
	if date_release_started:
		var now = Time.get_date_string_from_system()
		var time = Time.get_unix_time_from_datetime_string(now)
		var time_since_release = time - Manager.get_date_unix(date_release_started)
		if status == "ongoing":
			var release_total_episodes = min(time_since_release/release_schedule + 1, max_episodes if max_episodes else INF)
			total_episodes = release_total_episodes
			update_data()
	elif status == "watching":
		var time = Time.get_unix_time_from_system()
		var time_since_last_update = time - date_modified
		if time_since_last_update >= 604800:  # Update from watching to on hold if a week has passed
			status = "on hold"
			update_data()
	elif status == "on hold":
		var time = Time.get_unix_time_from_system()
		var time_since_last_update = time - date_modified
		if time_since_last_update >= 2629743:  # Update from watching to dropped if a month has passed
			status = "dropped"
			update_data()

func export():
	var data = {
			"item_name": item_name,
			"type": "season",
			"status": status,
			"icon": icon,
			"is_favorite": is_favorite,
			"genres": genres,
			"current_episode": current_episode,
			"total_episodes": total_episodes,
			"rating": rating,
			"notes": notes,
			"episodes_rewatched": episodes_rewatched,
			"date_started": date_started,
			"date_ended": date_ended,
			"date_modified": date_modified,
			"auto_track": auto_track
	}
	if status == "ongoing":
		data.merge({"release_schedule": release_schedule,
				"date_release_started": date_release_started,
				"max_episodes": max_episodes
			})
	var child_data = {}
	for child in children:
		child_data.merge({child.index: child.export()})
	if child_data:
		data.merge({"children": child_data})
	return data
	
