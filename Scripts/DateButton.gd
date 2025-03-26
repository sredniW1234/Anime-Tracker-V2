extends Button

@onready var date_selector = $DateSelector
@export var pre_text: String = "Date"
var date: Date

signal date_selected(date: String)

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
	date_selected.emit(text)
