extends OptionButton




# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents("Dialogue")

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if (file_name.ends_with("json") && !file_name.begins_with("#")):
					file_name.erase(file_name.length()-5, 5) # get rid of.wav
					self.add_item(file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path in Dialogue.")

func getCurrentFile():
	return self.get_item_text(self.selected)
