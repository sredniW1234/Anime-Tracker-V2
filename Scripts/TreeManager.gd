extends Tree

var root: TreeItem = null
var root_item: GeneralItem = null
<<<<<<< HEAD
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
=======
@onready var timer: Timer = $Timer
@onready var file_menu_button: MenuButton = $"../MenuBar/MarginContainer/HBoxContainer/FileMenuButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect("timeout", update_items)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
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
<<<<<<< HEAD
=======
	file_menu_button.get_popup().connect("id_pressed", menu_button_selected)
	#list[root_item] = {}

>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f

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
	
<<<<<<< HEAD
	item.update_data()
	parent.update_data()
	scroll_to_item(item.tree_item)
=======
	item.update()
	parent.update()
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
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


<<<<<<< HEAD
# Update all auto update items
func _on_timer_timeout() -> void:
	for parent: GeneralItem in Manager.ordered_list_keys:
		if parent.auto_track and parent.date_modified:
			parent.time_update()
		for child: GeneralItem in Manager.list[parent]:
			if child.auto_track and child.date_modified:
				child.time_update()
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Deselect"):
		deselect_all()
		Manager.currently_selected = null
=======
func update_items():
	for parent in Manager.ordered_list_keys:
		parent.update()
		for child in Manager.list[parent]:
			child.update()
	timer.start(1)

func load_item(item_properties: Dictionary):
	var item: GeneralItem = add_item(root_item, item_properties["Name"])
	# Set all common properties
	item.status = item_properties["Status"]
	item.icon = item_properties["Icon"]
	item.is_favorite = item_properties["Favorite"]
	item.rating = item_properties["Rating"]
	item.notes = item_properties["Notes"]
	item.date_started = item_properties["Date Started"]
	item.date_modified = item_properties["Date Modified"]
	item.auto_track = item_properties["Auto Track"]
	item.genres.append_array(item_properties["Genres"])
	# Season specific
	if item_properties.get("Type") == "Season":
		item.episodes = item_properties["Episodes"]
		item.episodes_rewatched = item_properties["Rewatches"]
		item.date_ended = item_properties["Date Ended"]
		if item.status == "ongoing":
			item.date_release_started = item_properties["Date Release Started"]
			item.release_schedule = item_properties["Release_Schedule"]
			item.max_episodes = item_properties["Max_Episodes"]
	elif item_properties.get("Type") == "Movie":
		item.length = item_properties["Movie"]
		item.rewatches = item_properties["Rewatches"]
	elif item_properties.get("Type") == "Book":
		pass
	return item

func load_tree(save_dict: Dictionary):
	for i in save_dict.keys():
		var parent_item_properties: Dictionary = save_dict[i]
		var parent_item = load_item(parent_item_properties)
		


func menu_button_selected(id):
	var selected_text = file_menu_button.get_popup().get_item_text(id)
	if selected_text == "Save":
		Manager.save_list("C:\\Users\\winde\\Desktop\\save_data.alt")
	if selected_text == "Load":
		var file = FileAccess.open("C:\\Users\\winde\\Desktop\\save_data.alt", FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		load_tree(data)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
