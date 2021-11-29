extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SOUND_REPEAT = 10 # plays the sound 10 times before stopping
var currRepeat = 0
var paused = false
var pauseDone = false
var markIter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var id = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# the sound that actually plays in the dialogue part, also the text being drawn
func _on_Timer_timeout():	
	# finished playing

	if (get_node("../TextDrawer").visibleText == get_node("..").totalLetters):
		get_node("Timer").stop()
		# Automatically stop the play button
		get_node("../Play/TextureButton").texture_normal = get_node("../Play").playButton
		get_node("../Play").currState = get_node("../Play").PAUSE
		
		#reenable the markers
		for i in range(get_node("../TextDrawer/Markers").get_child_count()):
			get_node("../TextDrawer/Markers").get_child(i).visible = true
	# iterate visibleText and play the sound
	else:
		# account for the markers
		# the numbers here represent the order of execution gates with pause and pauseDone
		var markers = get_node("..").markerList
		# change current marker when we get to the next iterator
		if (markIter != markers.size()-1 && !paused):
			if (get_node("../TextDrawer").visibleText >= markers[markIter+1]["mark"]):
				markIter += 1
				# if there's no pause just act like it doesn't exist
				if (markers[markIter]["pause"] if markers[markIter].has("pause") else 0 > 0): 
					paused = true
					get_node("Timer").wait_time = markers[markIter]["pause"]
					get_node("Timer").start()
					#print(1)
					pauseDone = false
		
		if (pauseDone):
			paused = false
			#print(3)
			
		
		# wait until we're not paused to update text
		if (!paused):
			get_node("../TextDrawer").visibleText += markers[markIter]["chars"] if markers[markIter].has("chars") else 1 # uses slider value
			# clamp to make sure we don't skip to a higher value than the total characters
			get_node("../TextDrawer").visibleText = clamp(get_node("../TextDrawer").visibleText, 0, get_node("..").totalLetters)
			
			if (!get_node("Sound").playing):
				get_node("Sound").stream = load("sounds/" + markers[markIter]["sound"] + ".wav")
				get_node("Sound").play()
				
			get_node("Timer").wait_time = markers[markIter]["speed"] if markers[markIter].has("speed") else 0.01
			get_node("Timer").start()
			#print(4)
		pauseDone = true
		#print(2)


# Sound button is pressed
func _on_TextureButton_toggled(button_pressed):

	if (get_node("Sounds/TextureButton").pressed):
		var currSound = get_node("Sounds/Add").get_item_text(get_node("Sounds/Add").get_selected_id())
		get_node("Sounds/SoundTest").stream = load("sounds/" + currSound + ".wav")
		get_node("Sounds/SoundTest").play()	
	else:
		currRepeat = 0
		get_node("Sounds/TextureButton").pressed = false	


# the sound in the tester finished
func _on_SoundTest_finished():
	if (currRepeat >= SOUND_REPEAT || !get_node("Sounds/TextureButton").pressed):
		currRepeat = 0
		get_node("Sounds/TextureButton").pressed = false

	else:
		currRepeat += 1
		get_node("Sounds/SoundTest").play()

	

# sound is selected, change the text sound.
func _on_Add_item_selected(index):
	var currSound = get_node("Sounds/Add").get_item_text(get_node("Sounds/Add").get_selected_id())
	get_node("Sound").stream = load("sounds/" + currSound + ".wav")
	get_node("..").updateMarker()


# Selecting Preset
func _on_Presets_item_selected(index):
	var preset = get_node("Presets").presets[index] #shorthand
	
	# assign the preset values to current values
	get_node("Speed/HSlider").value = preset["speed"]
	get_node("Chars/HSlider").value = preset["chars"]

	# We can't get the item with a name so we have to scroll through and find a match before assigning
	var id = 0
	while (get_node("Sounds/Add").get_item_text(id) != ""):
		if (get_node("Sounds/Add").get_item_text(id) == preset["sound"]):
			get_node("Sounds/Add").select(id)
			var currSound = get_node("Sounds/Add").get_item_text(get_node("Sounds/Add").get_selected_id())
			get_node("Sound").stream = load("sounds/" + currSound + ".wav")
			break
		id += 1
	get_node("..").updateMarker()
	# add to this if we have a preset with no existing sound file, keep things for erroring.
	# Set it up so that whenever the button is pressed, the drop down menu will update with any changes to the
	# directory. If a sound scanned from a preset isn't found, display "*NF(*file*)" for not found and use the no sound option


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
	
