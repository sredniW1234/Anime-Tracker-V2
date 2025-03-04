extends GeneralItem
class_name BookItem


var pages: String = "0/0" # E.g. "10/12"
var chapters: String = "0/0" # E.g. "10/12"
var children: Array[GeneralItem]
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
		
func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Chapters: %s | Rating: %.1f/10" % [status, chapters, rating])
