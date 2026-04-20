extends HFlowContainer

const genre_option = preload("res://Scenes/genre_button.tscn")
var actively_selected: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Clear all children
	for child in get_children().slice(1):
		child.queue_free()
	
	# Get the genre list
	var genre_list = []
	for genre in Manager.POSSIBLE_SEASON_GENRES + Manager.POSSIBLE_BOOK_GENRES:
		if not genre in genre_list:
			genre_list.append(genre)
	genre_list.sort()
	# Add each genre to the selction genre list
	for genre in genre_list:
		var genre_button = genre_option.instantiate()
		genre_button.text = genre
		add_child(genre_button)

func get_genres():
	actively_selected = []
	for child in get_children():
		if child.button_pressed:
			actively_selected.append(child.text.to_lower())
