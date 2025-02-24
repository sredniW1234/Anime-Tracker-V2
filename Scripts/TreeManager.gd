extends Tree

var root: TreeItem = null
var root_item: Item = null
var currently_selected: Item = null
var list = {}  # {Series Name Item: [Seasons], ...}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set tree properties
	columns = 3
	column_titles_visible = true
	set_column_title(0, "Title")
	set_column_title(1, "Stats")
	set_column_title(2, "Favorite")
	set_column_expand(0, true)
	set_column_expand(1, true)
	set_column_expand(2, true)
	set_column_expand_ratio(0, 10)
	set_column_expand_ratio(1, 3)
	set_column_expand_ratio(2, 2)
	hide_root = true
	
	root = create_item()
	root_item = Item.new()
	root_item.create(root, "root")
	#list[root_item] = {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Create and add the item to the list
func add_item(parent: Item, item_name: String):
	var item = Item.new()
	if parent.tree_item == root_item.tree_item:  # First level (Series Name)
		item.create(parent.tree_item, item_name)
		if parent not in list.keys():
			list[item] = []
	elif parent.parent == root_item.tree_item:
		item.create(parent.tree_item, item_name)
		list[parent].append(item)
	else:
		print(list)
		print(parent, parent.parent, root_item.tree_item)
		item.create(parent.parent, item_name)
		list[list.keys()[parent.get_index()]].append(item)
		#print(list, list.keys()[parent.get_index()])


func _on_add_pressed() -> void:
	self.add_item(currently_selected if currently_selected else root_item, str(randf()))
	#print(list)


func _on_item_selected() -> void:
	#print(get_selected().get_parent() == root_item.tree_item)
	var parent = get_selected().get_parent()
	# Get double parent instead of immediate parent for easier checking
	# root > root_item > Series > Season
	if parent.get_parent() == root:  # Level 1 (Series Name)
		currently_selected = list.keys()[get_selected().get_index()]
	elif parent.get_parent() == root_item.tree_item:  # Level 2 (Season Name)
		# Get parent in list keys > [] > get item in list > Item
		currently_selected = list[list.keys()[parent.get_index()]][get_selected().get_index()]
	else:
		currently_selected = null
