extends OptionButton



# Called when the node enters the scene tree for the first time.
func _init():
	self.add_item("None")
	dir_contents(loadPath())


# find the path that we set in portraitpath.txt to figure out where characters are
func loadPath():
	return GLOBALS.PICTURE_PATH
	
# Read in all the characters found in the directory
func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# No subdirectories, and only png files
			if !dir.current_is_dir() && file_name.ends_with(".png"):
				# strip the .wav from files
				self.add_item(file_name.rstrip(".png"))
			file_name = dir.get_next()
	else:
		print("No portraits directory found")
