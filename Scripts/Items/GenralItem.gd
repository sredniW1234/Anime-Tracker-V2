extends Node
class_name GeneralItem

const STATUS_COLORS = {"completed":Color(0, 1, 0),
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
var icon: String = "" # Icon path
var notes: String = "" # Notes for this item
var date_started: String  # Date item started
var date_ended: String  # Date item ended
var date_modified: int  # Date item was modified
var index: int  # Index in tree relative to parent
var rating: float = 0 # Rating out of 10
var is_favorite: bool = false # Is this item favorited
var genre: Array[String] = []
var auto_track: bool = true

# Create Item
func create(item_parent: TreeItem, _item_name: String) -> TreeItem:
	parent = item_parent
	tree_item = parent.create_child()
	item_name = _item_name
	index = tree_item.get_index()
	
	return tree_item

# Move this item before the specified TreeItem
func move_before():
	if is_instance_valid(tree_item):
		tree_item.move_before(tree_item.get_prev())
		index = tree_item.get_index()
		
	if parent.get_parent() == tree_item.get_tree().get_root():  # Level 1 (Series Name)
		var prev_item = Manager.ordered_list_keys[index-(1 if index-1 >= 0 else 0)]
		var curr_item = Manager.ordered_list_keys[index]
		Manager.ordered_list_keys[index-(1 if index-1 >= 0 else 0)] = curr_item
		Manager.ordered_list_keys[index] = prev_item
		
		
	else:  # Level 2 (Season Name)
		# Get parent in list keys > [] > get item in list > Item
		pass
	
# Move this item after the specified TreeItem
func move_after():
	if is_instance_valid(tree_item):
		tree_item.move_after(tree_item.get_prev())
		index = tree_item.get_index()
