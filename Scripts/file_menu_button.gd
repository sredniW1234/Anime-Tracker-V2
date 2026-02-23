extends MenuButton

@onready var save: FileDialog = $save
@onready var load_diag: FileDialog = $load
var save_location = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().id_pressed.connect(file_menu_pressed)

func file_menu_pressed(id: int) -> void:
	match id:
		0:
			Manager.new_tree.emit(false)
		1:
			if Manager.save_location:
				SaveManager.save(Manager.save_location)
			else:
				save_as()
		2:
			save_as()
		3:
			load_diag.popup()
			var file = FileAccess.open(save_location, FileAccess.READ)
			if file:
				var content = file.get_as_text()
				var data = JSON.parse_string(content)
				Manager.load_tree.emit(data)
			Manager.save_location = save_location


func save_as():
	save.popup()
	SaveManager.save(save_location)
	Manager.save_location = save_location

func _on_file_dialog_file_selected(path: String) -> void:
	save_location = path


func _on_load_file_selected(path: String) -> void:
	save_location = path


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Save"):
		file_menu_pressed(1)
	elif event.is_action_pressed("SaveAs"):
		file_menu_pressed(2)
	elif event.is_action_pressed("New"):
		file_menu_pressed(0)
	elif event.is_action_pressed("Open"):
		file_menu_pressed(3)
