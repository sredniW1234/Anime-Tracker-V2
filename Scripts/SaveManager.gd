extends Node


func save(path: String):
	if path:
		var savefile = FileAccess.open(path, FileAccess.WRITE)
		var data = {"list_name": Manager.list_name, "tree": {}}
		for parent in Manager.ordered_list_keys:
			data["tree"][parent.index] = parent.export()
		var data_as_json = JSON.stringify(data, "\t", false)
		savefile.store_string(data_as_json)
		savefile.close()
