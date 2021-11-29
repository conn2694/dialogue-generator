extends Control

# name of the file
var soundFx = "None"

func _ready():
	pass # Replace with function body.


func _on_SoundList_item_selected(index):
	soundFx = get_node("SoundList").get_item_text(index)
	get_node("..").updateControls()

# for when we want to update the value when we change markers/pages
func updateControls(soundFx):
	# Find the corresponding value in the node
	for i in range(get_node("SoundList").get_item_count()):
		if (soundFx == get_node("SoundList").get_item_text(i)):
			get_node("SoundList").select(i)
			self.soundFx = soundFx


