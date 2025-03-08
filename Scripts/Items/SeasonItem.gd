extends GeneralItem
class_name SeasonItem

var episodes: String = "0/0" # E.g. "10/12"
var status: String:
	set(new_status):
		status = new_status
		update_data()  # Default to completed
var release_schedule: int  # The release schedule for this item in unix time
var episodes_rewatched: int = 0  # The amount of episodes rewatched
var children: Array[GeneralItem]

func update_data():
	if is_instance_valid(tree_item):  # Make sure the tree item exists
		tree_item.set_custom_color(1, STATUS_COLORS[status])
		tree_item.set_text(1, "Status: %s | Episodes: %s | Rating: %0.1f/10" % [status, episodes, rating])
