extends Node

var currently_selected: GeneralItem:
	set(selection):
		currently_selected = selection
		if currently_selected:
			emit_signal("selected_changed", currently_selected)
var add_type: int = 0

var list = {}  # {Series Name Item: [Seasons], ...}
var ordered_list_keys = []
var list_name = ""
var save_location = ""

var current_tab = 0

var TYPES = [SeasonItem, MovieItem, BookItem]

const POSSIBLE_SEASON_STATUS = ["completed", "watching", "on hold", "ongoing", "dropped"]
const POSSIBLE_BOOK_STATUS = ["completed", "reading", "on hold", "dropped"]
const POSSIBLE_MOVIE_STATUS = ["completed", "watching", "on hold", "dropped"]

const POSSIBLE_SEASON_GENRES = ["Shonen", "Shojo", "Seinen", "Josei", "Action", "Adventure", "Comedy", "Cyberpunk", "Drama", "Fantasy", "Horror", "Isekai", "Magic", "Mecha", "Military", "Mystery", "Psychological", "Romance", "Sci-Fi", "Slice of Life", "Sports", "Superhero", "Supernatural", "Thriller"]
const POSSIBLE_BOOK_GENRES = ["Classic", "Contemporary", "Crime", "Dystopian", "Fantasy", "Historical Fiction", "Horror", "Literary Fiction", "Mystery/Detective", "Non-Fiction", "Philosophical", "Poetry", "Political", "Romance", "Science Fiction", "Self-Help", "Suspense", "Thriller", "Young Adult"]
const POSSIBLE_MOVIE_GENRES = ["Shonen", "Shojo", "Seinen", "Josei", "Action", "Adventure", "Comedy", "Cyberpunk", "Drama", "Fantasy", "Horror", "Isekai", "Magic", "Mecha", "Military", "Mystery", "Psychological", "Romance", "Sci-Fi", "Slice of Life", "Sports", "Superhero", "Supernatural", "Thriller"]

const SCHEDULE_TO_UNIX = {"weekly": 604800, "bi-weekly": 1209600, "monthly": 2629743}

signal selected_changed(currently_selected: GeneralItem)
signal load_tree(tree_data: Dictionary)
signal new_tree(ensured: bool)  # Ensured -> Whether the user has confirmed to create a new tree.
signal status_filter(filters: Array[String])

# Gets Unix time from current date
func get_date_unix(date) -> int:
	date = date.split(": ")[-1].split("/")
	var month = ("0" if int(date[0]) < 10 else "") + date[0]
	var day = ("0" if int(date[1]) < 10 else "") + date[1]
	var year = date[2]
	
	# Format to ISO 8601 format
	var formatted_date = year + "-" + month + "-" + day
	var unix = Time.get_unix_time_from_datetime_string(formatted_date)
	return unix

func export():
	var data = {}
	for item in ordered_list_keys:
		if is_instance_valid(item):
			data.merge(item.export())
