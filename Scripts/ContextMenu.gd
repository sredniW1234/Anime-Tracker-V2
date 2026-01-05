extends Control

@onready var _pm: PopupMenu = $PopupMenu

var _last_mouse_position

enum PopupIds {
	MoveUp = 0,
	MoveDown,
	Unparent,
	Reparent,
	Delete
}

const MoveUpIcon = preload("res://Assets/icons/circle-up.svg")
const MoveDownIcon = preload("res://Assets/icons/circle-down.svg")
const DeleteIcon = preload("res://Assets/icons/trash.svg")
const ReloadIcon = preload("res://Assets/icons/reload.svg")

func _ready() -> void:
	_pm.add_icon_item(MoveUpIcon, "Move Up", PopupIds.MoveUp)
	_pm.set_item_tooltip(PopupIds.MoveUp, "Moves the item up one in its current level.")
	_pm.add_icon_item(MoveDownIcon, "Move Down", PopupIds.MoveDown)
	_pm.set_item_tooltip(PopupIds.MoveDown, "Moves the item Down one in its current level.")
	_pm.add_icon_item(ReloadIcon, "Unparent Item", PopupIds.Unparent)
	_pm.set_item_tooltip(PopupIds.Unparent, "Moves the item up one level, clearing its parent.")
	_pm.add_icon_item(ReloadIcon, "Reparent Item To Below", PopupIds.Reparent)
	_pm.set_item_tooltip(PopupIds.Reparent, "Makes this item the child of the item directly below.")
	_pm.add_icon_item(DeleteIcon, "Delete", PopupIds.Delete)
	_pm.set_item_tooltip(PopupIds.Delete, "Deletes this item Permanently.")
	


func _input(event: InputEvent) -> void:
	if Manager.current_tab == 0 and Manager.currently_selected and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		# Handle reparenting
		if Manager.currently_selected.parent.get_parent() == Manager.currently_selected.tree_item.get_tree().get_root():
			_pm.set_item_disabled(PopupIds.Unparent, true)
			# Can reparent
			if "children" in Manager.currently_selected and not len(Manager.currently_selected.children) and Manager.currently_selected.index != len(Manager.ordered_list_keys)-1:
				_pm.set_item_disabled(PopupIds.Reparent, false)
			else:
				_pm.set_item_disabled(PopupIds.Reparent, true)
		else:
			# Can unparent
			_pm.set_item_disabled(PopupIds.Unparent, false)
			_pm.set_item_disabled(PopupIds.Reparent, true)

		_last_mouse_position = get_global_mouse_position()
		_pm.grab_focus()
		_pm.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, _pm.size.x, _pm.size.y))
		accept_event()


func _on_popup_menu_id_pressed(id: int) -> void:
	if PopupIds.MoveUp == id:
		Manager.currently_selected.move_before()
	elif PopupIds.MoveDown == id:
		Manager.currently_selected.move_after()
	elif PopupIds.Unparent == id:
		Manager.currently_selected.unparent()
	elif PopupIds.Reparent == id:
		Manager.currently_selected.re_parent()
	elif PopupIds.Delete == id:
		Manager.currently_selected.delete()
