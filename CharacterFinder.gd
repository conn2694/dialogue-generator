extends OptionButton



# Called when the node enters the scene tree for the first time.
func _init():
	self.add_item("N\/A")
	dir_contents(loadPath())


# find the path that we set in portraitpath.txt to figure out where characters are
func loadPath():
	return GLOBALS.PORTRAIT_PATH
	
# Read in all the characters found in the directory
func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# these dirs always show up and aren't relevant
				if (file_name != "." && file_name != ".."):
					self.add_item(file_name)
			file_name = dir.get_next()
	else:
		print("No portraits directory found")
