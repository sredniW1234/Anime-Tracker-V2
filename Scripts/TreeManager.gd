extends Tree

var root: TreeItem = null
var root_item: GeneralItem = null
var collapsed: bool = false

@onready var timer: Timer = $"../../../../../../Timer"
@onready var tab_container: TabContainer = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#list[root_item] = {}
	create_tree()
	Manager.connect("load_tree", load_tree)
	Manager.connect("new_tree", new_tree)
	Manager.connect("status_filter", filter_status)

func create_tree():
	clear()
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
	collapsed = false
	
	Manager.list = {}
	Manager.ordered_list_keys = []
	Manager.currently_selected = null
	Manager.save_location = ""
	tab_container.current_tab = 0
	root = create_item()
	root_item = GeneralItem.new()
	root_item.create(root, Manager.list_name)

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
	
	item.update_data()
	parent.update_data()
	scroll_to_item(item.tree_item)
	return item


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


# Update all auto update items
func _on_timer_timeout() -> void:
	for parent: GeneralItem in Manager.ordered_list_keys:
		if is_instance_valid(parent) and parent.auto_track and parent.date_modified:
			parent.time_update()
		for child: GeneralItem in Manager.list[parent]:
			if child.auto_track and child.date_modified:
				#print(child)
				#child.time_update()
				pass
				# TODO: FIX THIS
				# ISSUE: Tying to assign invalid previously freed instance.
	timer.start(1)


func load_item(item_data: Dictionary, parent = null):
	if parent == null:
		parent = root_item
	if item_data.get("type") == "season":
		Manager.add_type = 0
	elif item_data.get("type") == "movie":
		Manager.add_type = 1
	elif item_data.get("type") == "book":
		Manager.add_type = 2
	var item = add_item(parent, item_data["item_name"])
	for key in item_data.keys():
		if key in item and key != "children":
			item.set(key, item_data[key])
	item.update_data()
	return item


func load_tree(savefile: Dictionary):
	Manager.list_name = savefile["list_name"]
	create_tree()
	for i in savefile["tree"].keys():
		var parent_data = savefile["tree"][i]
		var parent_item = load_item(parent_data)
		if "children" in parent_data:
			for child in parent_data["children"]:
				var child_data = parent_data["children"][child]
				load_item(child_data, parent_item)


func new_tree(sure: bool):
	if sure:
		create_tree()
	

func filter_status(filters: Array[String]):
	for item in Manager.ordered_list_keys:
		if (item.status in filters) or ("all" in filters) or (filters == []):
			item.tree_item.visible = true
		else:
			item.tree_item.visible = false
		


func _on_toggle_collapse_pressed() -> void:
	collapsed = not collapsed
	for item in Manager.ordered_list_keys:
		item.tree_item.set_collapsed_recursive(collapsed)


func _on_tab_container_tab_changed(tab: int) -> void:
	Manager.current_tab = tab
	if Manager.currently_selected:
		Manager.currently_selected.update_data()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Deselect"):
		deselect_all()
		Manager.currently_selected = null


func _on_item_activated() -> void:
	Manager.current_tab = 1
	tab_container.current_tab = 1
