extends Control

@onready var left: ItemList = $VBoxContainer/HBoxContainer/ItemList
@onready var right: ItemList = $VBoxContainer/HBoxContainer/ItemList2


func calculate_stats():
	var total_shows = len(Manager.ordered_list_keys)
	left.set_item_text(0, "Total Shows: " + str(total_shows))
	
	# Get all item types and seperate them
	var all_seasons: Array[SeasonItem] = []
	var all_movies: Array[MovieItem] = []
	for key in Manager.ordered_list_keys:
		# All parents
		if Manager.list[key] == [] and is_instance_of(key, SeasonItem):
			all_seasons.append(key)
		elif is_instance_of(key, MovieItem):
			all_movies.append(key)
		else:
			# All children
			for child in Manager.list[key]:
				if is_instance_of(child, SeasonItem):
					all_seasons.append(child)
				elif is_instance_of(child, MovieItem):
					all_movies.append(child)
	left.set_item_text(1, "Total Seasons: " + str(len(all_seasons)))
	
	# Grab total episode count and watched episode count
	var total_episode_count = 0
	var watched_episode_count = 0
	for season in all_seasons:
		total_episode_count += int(season.episodes.split("/")[1])
		watched_episode_count += int(season.episodes.split("/")[0]) + season.episodes_rewatched
	left.set_item_text(2, "Total Episodes: " + str(total_episode_count))
	left.set_item_text(3, "Episodes Watched (W/ Rewatched): " + str(watched_episode_count))
	# Index 4 is empty seperator
	left.set_item_text(5, "Movies Watched: " + str(len(all_movies)))
	
	var total_movie_watch_hours = 0
	for movie in all_movies:
		total_movie_watch_hours += movie.length * movie.rewatched
	left.set_item_text(6, "Hours Watched (W/ Rewatched): %dh %dm" % [int(total_movie_watch_hours/60), total_movie_watch_hours%60])


func _on_tab_container_tab_changed(tab: int) -> void:
	if tab == 2:
		calculate_stats()
