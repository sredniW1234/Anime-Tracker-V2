extends Node
class_name Item

const colors = {"complete":Color(0, 1, 0),
 "watching":Color(0.5, 1, 0.5), "ongoing":Color(1, 0.6, 0), "on hold":Color(0.9, 0.2, 0.9),
 "started":Color(0.5, 0.75, 1), "dropped":Color(1, 0, 0), "":Color(0, 0, 0)}

var parent: TreeItem
var tree_item: TreeItem
var item_name: String:
	set(new_name):
		item_name = new_name
		if tree_item and is_instance_valid(tree_item):
			tree_item.set_text(0, item_name)
	get:
		return item_name
var status: String
var icon: String
var notes: String
var date_started: String
var date_ended: String
var segment: int
var max_segments: int
var rewatches: int
var movie_length: int
var index: int
var rating: float
var is_favorite: bool
var children = []

func create(item_parent: TreeItem, _item_name: String) -> TreeItem:
	parent = item_parent
	tree_item = parent.create_child()
	item_name = _item_name
	index = parent.get_child_count()
	
	return tree_item
