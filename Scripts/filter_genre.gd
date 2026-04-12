extends MenuButton

@onready var possible_genres: HFlowContainer = $"../../../../../../../../../Filter Genres/MarginContainer/VBoxContainer/ScrollContainer/Possible Genres"

@onready var filter_genres: Panel = $"../../../../../../../../../Filter Genres"
	


func _on_select_genres_pressed() -> void:
	filter_genres.hide()
	possible_genres.get_genres()
	Manager.emit_signal("genre_filter", possible_genres.actively_selected)


func _on_about_to_popup() -> void:
	filter_genres.show()
