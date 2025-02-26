extends Button

@onready var date_selector = $DateSelector
@export var pre_text: String = "Date"

func _ready() -> void:
	connect("pressed", display_date_selector)
	date_selector.connect("date_selected", show_date_selected)


func display_date_selector():
	date_selector._toggled(true)


func show_date_selected(date_obj: Date):
	var date = str(date_obj.month()) + "/" + str(date_obj.day()) + "/" + str(date_obj.year())
	text = pre_text + date
