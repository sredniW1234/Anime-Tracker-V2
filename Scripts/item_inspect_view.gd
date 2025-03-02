extends Control

@onready var season_name: LineEdit = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/SeasonName
@onready var rating_slider: HSlider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingSlider
var item: GeneralItem = null
@onready var rating_label: Label = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/VBoxContainer/RatingLabel

func _ready() -> void:
	Manager.connect("selected_changed", load_view)


func load_view(current_item: GeneralItem):
	item = current_item
	season_name.text = item.item_name
	rating_slider.value = item.rating
	rating_slider.emit_signal("value_changed", rating_slider.value)

func _on_rating_slider_value_changed(value: float) -> void:
	rating_label.text = "Rating: %s/10" % (str(value) + (".0" if int(value) == value else ""))
	if item:
		item.rating = value


func _on_season_name_text_changed(new_text: String) -> void:
	if item:
		item.item_name = new_text
