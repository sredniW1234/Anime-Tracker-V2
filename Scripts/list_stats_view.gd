extends Control

@onready var left: ItemList = $MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer2/ItemList
@onready var right: ItemList = $MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ItemList2


func calculate_stats():
	var total_shows = len(Manager.ordered_list_keys)
	left.set_item_text(0, "Total Shows: " + str(total_shows))
	
	# Get all item types and seperate them
	var all_seasons: Array[SeasonItem] = []
	var all_movies: Array[MovieItem] = []
	for show in Manager.ordered_list_keys:
		# All parents
		if Manager.list[show] == [] and is_instance_of(show, SeasonItem):
			all_seasons.append(show)
		elif is_instance_of(show, MovieItem):
			all_movies.append(show)
		else:
			# All children
			for child in Manager.list[show]:
				if is_instance_of(child, SeasonItem):
					all_seasons.append(child)
				elif is_instance_of(child, MovieItem):
					all_movies.append(child)
	left.set_item_text(1, "Total Seasons: " + str(len(all_seasons)))
	
	# Grab total episode count and watched episode count
	var total_episode_count = 0
	var watched_episode_count = 0
	for season in all_seasons:
		total_episode_count += season.total_episodes
		watched_episode_count += season.current_episode + season.episodes_rewatched
	left.set_item_text(2, "Total Episodes: " + str(total_episode_count))
	left.set_item_text(3, "Episodes Watched (W/ Rewatched): " + str(watched_episode_count))
	# Index 4 is empty seperator
	left.set_item_text(5, "Movies Watched: " + str(len(all_movies)))
	
	var total_movie_watch_hours = 0
	for movie in all_movies:
		total_movie_watch_hours += movie.length * (movie.rewatched if movie.rewatched else 1)
	left.set_item_text(6, "Hours Watched (W/ Rewatched): %dh %dm" % [int(total_movie_watch_hours/60), total_movie_watch_hours%60])
	
	# -------------- Right Side ------------
	var status_stats = {"completed":0, "watching":0, 
	"ongoing":0, "on hold":0, 
	"started":0, "dropped":0, "":0}
	for season in all_seasons:
		status_stats[season.status] += 1
	right.set_item_text(0, "Shows:")
	right.set_item_text(1, "% Completed: " + str(status_stats["completed"] / len(all_seasons)) + "%")
	right.set_item_text(2, "% Currently Watching: " + str(status_stats["watching"] / len(all_seasons)) + "%")
	right.set_item_text(3, "% On Hold: " + str(status_stats["on hold"] / len(all_seasons)) + "%")
	right.set_item_text(4, "% Ongoing: " + str(status_stats["ongoing"] / len(all_seasons)) + "%")
	right.set_item_text(5, "% Dropped: " + str(status_stats["dropped"] / len(all_seasons)) + "%")
	right.set_item_text(6, "% Without a Status: " + str(status_stats[""] / len(all_seasons)) + "%")
	#right.set_item_text(5, "Shows Started: " + str(status_stats["started"] / len(all_seasons)))
	
	# movies
	status_stats = {"completed":0, "watching":0, "on hold":0, "dropped":0, "":0}
	for movie in all_movies:
		status_stats[movie.status] += 1
	right.set_item_text(8, "Movies:")
	right.set_item_text(9, "% Completed: " + str(status_stats["completed"]))
	right.set_item_text(10, "% Currently Watching: " + str(status_stats["watching"]))
	right.set_item_text(11, "% On Hold: " + str(status_stats["on hold"]))
	right.set_item_text(12, "% Dropped: " + str(status_stats["dropped"]))
	right.set_item_text(13, "% Without a Status: " + str(status_stats[""]))


func _on_tab_container_tab_changed(tab: int) -> void:
	if tab == 2:
		calculate_stats()
