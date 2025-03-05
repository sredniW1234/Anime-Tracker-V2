extends Control

@onready var _pm: PopupMenu = $PopupMenu

var _last_mouse_position

enum PopupIds {
	MoveUp = 0,
	ModeDown,
	Delete
}

var MoveUpIcon = preload("res://Assets/icons/circle-up.svg")
var MoveDownIcon = preload("res://Assets/icons/circle-down.svg")
var DeleteIcon = preload("res://Assets/icons/trash.svg")


func _ready() -> void:
	_pm.add_icon_item(MoveUpIcon, "Move Up", PopupIds.MoveUp)
	_pm.add_icon_item(MoveDownIcon, "Move Down", PopupIds.ModeDown)
	_pm.add_icon_item(DeleteIcon, "Delete", PopupIds.Delete)
	


func _input(event: InputEvent) -> void:
	if Manager.currently_selected and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		_last_mouse_position = get_global_mouse_position()
		_pm.grab_focus()
		_pm.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, _pm.size.x, _pm.size.y))
		accept_event()


func _on_popup_menu_id_pressed(id: int) -> void:
	if PopupIds.MoveUp == id:
		Manager.currently_selected.move_before()
	elif PopupIds.ModeDown == id:
		Manager.currently_selected.move_after()
	elif PopupIds.Delete == id:
		Manager.currently_selected.delete()
