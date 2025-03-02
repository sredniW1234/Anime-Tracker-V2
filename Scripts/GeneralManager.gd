extends Node

@export var currently_selected: GeneralItem:
	set(selection):
		currently_selected = selection
		if currently_selected:
			emit_signal("selected_changed", currently_selected)
@export var TYPES: Array = [SeasonItem, MovieItem, BookItem]
@export var add_type: int = 0

signal selected_changed(currently_selected: GeneralItem)
