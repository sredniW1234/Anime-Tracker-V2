extends Button

@onready var date_selector = $DateSelector
@export var pre_text: String = "Date"
var date: Date

signal date_selected(date, unix)


func _ready() -> void:
	connect("pressed", display_date_selector)
	date_selector.connect("date_selected", show_date_selected)


func display_date_selector():
	date_selector._toggled(true)


func show_date_selected(date_obj: Date):
	var date_text = str(date_obj.month()) + "/" + str(date_obj.day()) + "/" + str(date_obj.year())
	date = date_obj
	text = pre_text + date_text
	date_selected.emit(text, get_date_unix())


# Gets Unix time from current date
func get_date_unix() -> int:
	var month = ("0" if date.month() < 10 else "") + str(date.month())
	var day = ("0" if date.day() < 10 else "") + str(date.day())
	var year = str(date.year())
	
	# Format to ISO 8601 format
	var formatted_date = year + "-" + month + "-" + day
	var unix = Time.get_unix_time_from_datetime_string(formatted_date)
	return unix
