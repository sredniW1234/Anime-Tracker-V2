extends Node

@export var currently_selected: GeneralItem = null
@export var TYPES: Array = [SeasonItem, MovieItem, BookItem]
@export var add_type: GeneralItem = TYPES[0].new()
