extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Create a new preset with the specified name, if it is a previous name, it will overwrite it
# rewrite the file
func _on_SaveBox_confirmed():
	var saveTxt = get_node("SaveBox/LineEdit").text
	var found = false
	var posReplace
	for i in range(get_node("OptionButton").presets.size()):

		if (get_node("OptionButton").presets[i]["name"] == saveTxt):
			found = true
			get_node("OptionButton").presets.remove(i)
			break
	if (found):
		get_node("OptionButton").add(saveTxt)
	else:
		get_node("OptionButton").add_item(saveTxt) # New name, let the person use it right away
		get_node("OptionButton").add(saveTxt)
		
	# Select the new preset we made
	var id = 0
	while (get_node("OptionButton").get_item_text(id) != ""):
		if (get_node("OptionButton").get_item_text(id) == saveTxt):
			get_node("OptionButton").select(id)
			break
		id += 1
	get_node("..").updateMarker()

# Change to a dfferent preset, change all the controls
func _on_OptionButton_item_selected(index):
	var preset = get_node("OptionButton").presets[index] #shorthand
	
	# assign the preset values to current values
	get_node("../Waves/Amp/HSlider").value = preset["waves"]["amp"]
	get_node("../Waves/Wave/HSlider").value = preset["waves"]["wave"]
	get_node("../Waves/Pi/HSlider").value = preset["waves"]["period"]
	
	get_node("../Speed/Speed/HSlider").value = preset["textCrawl"]["speed"]
	get_node("../Speed/Chars/HSlider").value = preset["textCrawl"]["lettersAdded"]
	# We can't get the item with a name so we have to scroll through and find a match before assigning
	var id = 0
	while (get_node("../Speed/Sounds/Add").get_item_text(id) != ""):
		if (get_node("../Speed/Sounds/Add").get_item_text(id) == preset["textCrawl"]["sound"]):
			get_node("../Speed/Sounds/Add").select(id)
			var currSound = get_node("../Speed/Sounds/Add").get_item_text(get_node("../Speed/Sounds/Add").get_selected_id())
			get_node("../Speed/Sound").stream = load("sounds/" + currSound + ".wav")
			break
		id += 1
	
	get_node("../Color/Main/ColorRect").color = Color(preset["color"])
	get_node("../Delay/Main/HSlider").value = preset["delay"]
	get_node("../Sfx").updateControls(preset["sound_effect"])
	
	get_node("../Box Controls").updateMarkerControls(
		preset["globalControls"]["dimmed"],
		preset["globalControls"]["shocked"],
		preset["globalControls"]["prompt"]
	)
	get_node("../Box Controls").updateControls(
		preset["globalControls"]["centered"],
		preset["globalControls"]["narrator"],
		preset["globalControls"]["interrupt"]
	)

	
	get_node("../TextDrawer").update_text()
	
