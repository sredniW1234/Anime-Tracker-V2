extends Tree

var root: TreeItem = null
var root_item: GeneralItem = null
@onready var timer: Timer = $Timer
@onready var file_menu_button: MenuButton = $"../MenuBar/MarginContainer/HBoxContainer/FileMenuButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect("timeout", update_items)
	# Set tree properties
	columns = 3
	column_titles_visible = true
	set_column_title(0, "Title")
	set_column_title(1, "Stats")
	set_column_title(2, "Favorite")
	set_column_expand(0, true)
	set_column_expand(1, true)
	set_column_expand(2, true)
	set_column_expand_ratio(0, 5)
	set_column_expand_ratio(1, 4)
	set_column_expand_ratio(2, 0)
	hide_root = true
	
	root = create_item()
	root_item = GeneralItem.new()
	root_item.create(root, Manager.list_name)
	file_menu_button.get_popup().connect("id_pressed", menu_button_selected)
	#list[root_item] = {}


# Create and add the item to the list
func add_item(parent: GeneralItem, item_name: String):
	var item: GeneralItem = Manager.TYPES[Manager.add_type].new()
	
	if parent.tree_item == root_item.tree_item:  # First level (Series Name)
		item.create(parent.tree_item, item_name)
		if parent not in Manager.ordered_list_keys:
			Manager.list[item] = []
			Manager.ordered_list_keys.append(item)
	elif parent.parent == root_item.tree_item:
		item.create(parent.tree_item, item_name)
		Manager.list[parent].append(item)
		if "children" in parent:
			parent.children.append(item)
	else:
		item.create(parent.parent, item_name)
		Manager.list[Manager.list.keys()[parent.parent.get_index()]].append(item)
		if "children" in parent:
			parent.children.append(item)
	
	item.update()
	parent.update()


func _on_add_pressed() -> void:
	self.add_item(Manager.currently_selected if Manager.currently_selected else root_item, "CHANGE ME!")


func _on_item_selected() -> void:
	var parent = get_selected().get_parent()
	# Get double parent instead of immediate parent for easier checking
	# root > root_item > Series > Season
	if parent.get_parent() == root:  # Level 1 (Series Name)
		Manager.currently_selected = Manager.ordered_list_keys[get_selected().get_index()]
	elif parent.get_parent() == root_item.tree_item:  # Level 2 (Season Name)
		# Get parent in list keys > [] > get item in list > Item
		Manager.currently_selected = Manager.list[Manager.ordered_list_keys[parent.get_index()]][get_selected().get_index()]
	else:
		Manager.currently_selected = null


func _on_nothing_selected() -> void:
	deselect_all()
	Manager.currently_selected = null


func update_items():
	for parent in Manager.ordered_list_keys:
		parent.update()
		for child in Manager.list[parent]:
			child.update()
	timer.start(1)


func menu_button_selected(id):
	var selected_text = file_menu_button.get_popup().get_item_text(id)
	if selected_text == "Save":
		Manager.save_list("C:\\Users\\winde\\Desktop\\save_data.alt")
