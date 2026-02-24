extends Control

@onready var buttons: FlowContainer = $PanelContainer/CenterContainer/Buttons
@onready var new_list_panel: FlowContainer = $PanelContainer/CenterContainer/NewListPanel
@onready var new_list_name: LineEdit = $PanelContainer/CenterContainer/NewListPanel/NewListName
@onready var load_diag: FileDialog = $"PanelContainer/CenterContainer/Buttons/Open List/load"
var save_location = ""


func _on_new_list_pressed() -> void:
	buttons.hide()
	new_list_panel.show()


func _on_create_pressed() -> void:
	if new_list_name.text:
		Manager.list_name = new_list_name.text
	else:
		Manager.list_name = "New List"
	get_tree().change_scene_to_file("res://Scenes/anime_list.tscn")


func _on_open_list_pressed() -> void:
	load_diag.popup()
	if save_location:
		Manager.save_location = save_location
		Manager.loading_from_main = true
		get_tree().change_scene_to_file("res://Scenes/anime_list.tscn")


func _on_load_file_selected(path: String) -> void:
	save_location = path
