extends Control

# name of the file
var image = "None"

func _ready():
	pass # Replace with function body.


func _on_Images_item_selected(index):
	image = get_node("Images").get_item_text(index)
	get_node("..").updateControls()

# for when we want to update the value when we change markers/pages
func updateControls(image):
	# Find the corresponding value in the node
	for i in range(get_node("Images").get_item_count()):
		if (image == get_node("Images").get_item_text(i)):
			get_node("Images").select(i)
			self.image = image

