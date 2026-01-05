extends CenterContainer

@onready var new_list_name: LineEdit = $VBoxContainer/HBoxContainer/HBoxContainer/NewListName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Manager.connect("new_tree", popup)

	
func popup(sure: bool):
	if not sure:
		show()


func _on_yes_pressed() -> void:
	if new_list_name.text != "":
		Manager.list_name = new_list_name.text
		hide()
		Manager.emit_signal("new_tree", true)


func _on_no_pressed() -> void:
	hide()
