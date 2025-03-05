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
			name = item_name
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
	name = item_name
	
	return tree_item

# Move this item before the specified TreeItem
func move_before():
	if is_instance_valid(tree_item) and index > 0:
		tree_item.move_before(tree_item.get_prev())
		index = tree_item.get_index()
		
		var list: Array
		if parent.get_parent() == tree_item.get_tree().get_root():
			list = Manager.ordered_list_keys
		else:
			list = Manager.list[Manager.ordered_list_keys[parent.get_index()]]
		
		var curr_item = list[index]
		var prev_item = list[index+1]
		list[index] = prev_item
		list[index+1] = curr_item
			
# Move this item after the specified TreeItem
func move_after():
	var list: Array
	
	if is_instance_valid(tree_item):
		if parent.get_parent() == tree_item.get_tree().get_root():  # 1st level, (Season Name)
			if index < len(Manager.ordered_list_keys):
				tree_item.move_after(tree_item.get_next())
				index = tree_item.get_index()
				list = Manager.ordered_list_keys
		else:
			if index < len(Manager.list[Manager.ordered_list_keys[parent.get_index()]])-1:
				tree_item.move_after(tree_item.get_next())
				index = tree_item.get_index()
				list = Manager.list[Manager.ordered_list_keys[parent.get_index()]]
		
		if list:
			var curr_item = list[index]
			var next_item = list[index-1]
			list[index] = next_item
			list[index-1] = curr_item


func delete():
	if tree_item:
		Manager.currently_selected = null
		tree_item.get_tree().deselect_all()
		tree_item.free()
		if self in Manager.list.keys():
			Manager.list.erase(self)
		else:
			Manager.list[Manager.ordered_list_keys[parent.get_index()]].remove_at(index)
		queue_free()
