extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# when we switch presets
func _on_Presets_item_selected(index):
	var preset = get_node("Presets").presets[index] #shorthand
	
	# assign the preset values to current values
	get_node("Amp/HSlider").value = preset["amp"]
	get_node("Wave/HSlider").value = preset["wave"]
	get_node("Pi/HSlider").value = preset["pi"]


# saving new preset
func _on_ConfirmationDialog_confirmed():

	var saveTxt = get_node("ConfirmationDialog/LineEdit").text
	var found = false
	var posReplace
	for i in range(get_node("Presets").presets.size()):

		if (get_node("Presets").presets[i]["name"] == saveTxt):
			found = true
			get_node("Presets").presets.remove(i)
			break
	if (found):
		get_node("Presets").add(saveTxt)
	else:
		get_node("Presets").add_item(saveTxt) # New name, let the person use it right away
		get_node("Presets").add(saveTxt)
		
	# Select the new preset we made
	var id = 0
	while (get_node("Presets").get_item_text(id) != ""):
		if (get_node("Presets").get_item_text(id) == saveTxt):
			get_node("Presets").select(id)
			break
		id += 1
	get_node("..").updateMarker()
