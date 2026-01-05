extends MenuButton


func _ready() -> void:
	get_popup().id_pressed.connect(filter_check_pressed)


func filter_check_pressed(id:int):
	var index = get_popup().get_item_index(id)
	get_popup().set_item_checked(index, not get_popup().is_item_checked(index))
	send_signal()


func send_signal():
	var checked: Array[String] = []
	for item_index in get_popup().item_count:
		if get_popup().is_item_checked(item_index):
			checked.append(get_popup().get_item_text(item_index).to_lower())
	Manager.emit_signal("status_filter", checked)
