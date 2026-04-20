extends Control

@onready var autosave_timer: Timer = $AutosaveTimer
@onready var animation_player: AnimationPlayer = $Label/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.connect("new_tree", reset)
	Manager.connect("load_tree", reset)
	SaveManager.connect("saved", reset)
	reset()


func reset(_params=[]):
	autosave_timer.start(SaveManager.current_settings.get_value("saving", "autosave_interval", 300))
	hide()


func _on_autosave_timer_timeout() -> void:
	# Autosave turned on
	if SaveManager.current_settings.get_value("saving", "autosave", true):
		if Manager.save_location:
			SaveManager.save(Manager.save_location)
			animation_player.play("Autosave")
			show()
