extends OptionButton



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# find the path that we set in portraitpath.txt to figure out where characters are
func loadPath():
	return GLOBALS.PORTRAIT_PATH

# Read in all the faces of a character in directory
func loadFaces(path, character):
	var dir = Directory.new()
	if dir.open(path + "/" + character) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# No subdirectories, and only png files
			if !dir.current_is_dir() && file_name.ends_with(".png"):
				self.add_item(file_name)
			file_name = dir.get_next()


# Character has changed
func _on_Character_item_selected(index):
	self.clear() # clear previous faces before loading in new ones
	get_node("..").data.character = get_node("../Character").get_item_text(index)
	self.add_item("N\/A")
	loadFaces(loadPath(), get_node("../Character").get_item_text(index))
	get_node("../../..").updateMarker()
