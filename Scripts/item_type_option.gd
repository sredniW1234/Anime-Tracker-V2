extends OptionButton


@export var icons: Array[CompressedTexture2D] = []

func _ready():
	connect("item_selected", set_icon)


func set_icon(index: int):
	Manager.add_type = index
