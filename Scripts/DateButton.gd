extends Button

@onready var date_selector = $DateSelector
@export var pre_text: String = "Date"
var date: Date

<<<<<<< HEAD
signal date_selected(date, unix)

=======
signal date_selected(date: String)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f

func _ready() -> void:
	connect("pressed", display_date_selector)
	date_selector.connect("date_selected", show_date_selected)


func display_date_selector():
	date_selector._toggled(true)

func select_date(date_str: String):  # mm-dd-yyyy
	var date_lst = date_str.split("/")
	if len(date_lst) >= 3:
		date.set_day(int(date_lst[-2]))
		date.set_month(int(date_lst[-3]))
		date.set_year(int(date_lst[-1]))
		show_date_selected(date)
	else:
		text = name

func show_date_selected(date_obj: Date):
	var date_text = str(date_obj.month()) + "/" + str(date_obj.day()) + "/" + str(date_obj.year())
	date = date_obj
	text = pre_text + date_text
<<<<<<< HEAD
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
=======
	date_selected.emit(text)
>>>>>>> be1238647f7a9f3c14b10e0829de9669d302b45f
