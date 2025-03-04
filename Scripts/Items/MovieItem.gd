extends GeneralItem
class_name MovieItem

var length: int = 0 # Length of the movie in minutes
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
		
func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Length: %dh %dm | Rating: %.1f/10" % [status, length/60, length%60, rating])
