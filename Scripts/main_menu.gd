extends Control

@onready var buttons: FlowContainer = $PanelContainer/CenterContainer/Buttons
@onready var new_list_panel: FlowContainer = $PanelContainer/CenterContainer/NewListPanel
@onready var new_list_name: LineEdit = $PanelContainer/CenterContainer/NewListPanel/NewListName



func _on_new_list_pressed() -> void:
	buttons.hide()
	new_list_panel.show()


func _on_create_pressed() -> void:
	Manager.list_name = new_list_name.text
	get_tree().change_scene_to_file("res://Scenes/anime_list.tscn")
