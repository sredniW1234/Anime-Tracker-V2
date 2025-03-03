extends Node
class_name GeneralItem

const STATUS_COLORS = {"complete":Color(0, 1, 0),
 "watching":Color(0.5, 1, 0.5), "reading":Color(0.5, 1, 0.5),
 "ongoing":Color(1, 0.6, 0), "on hold":Color(0.9, 0.2, 0.9),
 "started":Color(0.5, 0.75, 1), "dropped":Color(1, 0, 0), "":Color(0, 0, 0)}

var parent: TreeItem
var tree_item: TreeItem
var item_name: String:  # Name of the item
	set(new_name):
		item_name = new_name
		if tree_item and is_instance_valid(tree_item):
			tree_item.set_text(0, item_name)
	get:
		return item_name
var icon: String  # Icon path
var notes: String  # Notes for this item
var date_started: String  # Date item started
var date_ended: String  # Date item ended
var date_modified: float  # Date item was modified
var index: int  # Index in tree relative to parent
var rating: float  # Rating out of 10
var is_favorite: bool  # Is this item favorited
var genre: Array[String]

var auto_track: bool = true  # Whether or not to autotrack this item

# Create Item
func create(item_parent: TreeItem, _item_name: String) -> TreeItem:
	parent = item_parent
	tree_item = parent.create_child()
	item_name = _item_name
	index = parent.get_child_count()
	
	return tree_item
