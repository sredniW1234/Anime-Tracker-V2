extends TextureRect


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


func _ready() -> void:
	animation_player.play("spin")
	SaveManager.connect("saved", reset)
	reset()

func reset():
	timer.start(SaveManager.current_settings.get_value("saving", "unsaved_warning_timer", 120))
	hide()

func _on_timer_timeout() -> void:
	show()
