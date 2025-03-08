extends GeneralItem
class_name BookItem


var pages: String = "0/0" # E.g. "10/12"
var volumes: int = 0  # number of volumes (PARENT ONLY!)
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
var pages_reread: int = 0  # Number of pages reread
var children: Array[GeneralItem]


# Update data column in tree view
func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		if len(children) > 0:
			tree_item.set_text(1, "Status: %s | vol: %d | Rating: %.1f/10" % [status, volumes, rating])
		else:
			tree_item.set_text(1, "Status: %s | Pages: %s | Rating: %.1f/10" % [status, pages, rating])
