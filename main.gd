extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currDia = ""
var currLetter = 0
var totalLetters = 0
var screenHeight = 0
#var charLen = []
var chrlen
var textSelected = true # by default we're already able to type in the textbox

var currMarker = 0 # keeps track of what index we're in
var markerList = []
var markerAdded = false
var playingPreview = false
var ctrlPressed = false





# Called when the node enters the scene tree for the first time.
func _ready():
	chrlen = get_node("TextDrawer").charLen
	screenHeight = get_viewport_rect().size.y
	print(screenHeight)



func _input(event):
	
	if (event.is_action_released("ctrl")):
		print("unpress")
		get_node("Page").deleteBtnCheck(false)
	elif (event.is_action_pressed("ctrl")):
		print("press")
		get_node("Page").deleteBtnCheck(true)
	
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed):
		print("mouse position: ", event.position.y)
		get_node("Portraits/Preview").hide()
		# focus text box and make sure we're not selecting from a drop down
		if (event.position.y > 192-224+screenHeight and 
		!get_node("Speed/Presets").pressed and 
		!get_node("Waves/Presets").pressed and 
		!get_node("Speed/Sounds/Add").pressed and 
		!get_node("Global Preset/OptionButton").pressed and
		!get_node("File Select/CurrentFile").pressed and
		!get_node("Object/CurrentObject").pressed and 
		!get_node("Sfx/SoundList").pressed and
		!get_node("Music/Songs").pressed and
		!get_node("Picture/Images").pressed and
		!get_node("BG/BG").pressed and
		!playingPreview and
		!get_node("Portraits").arePortraitButtonsPressed()):
			textSelected = true
			unfocus_all()
			# first line
			if (event.position.y < 207-224+screenHeight):
				var notReached = true # for if we click farther then there are any letters
				var endLineChar = 0 # keeps track of what the last character is so we can jump to it
				for i in range(chrlen.size()):
					if (chrlen[i].y == 0): # first line
						endLineChar = i # update will stop when we end up at a new line
						# 15 for text offset, 3 for halfway poit of most characters, 18 in total
						if (chrlen[i].x > event.position.x-18): 
							notReached = false 
							# we have found two characters to put the cursor in between
							# based off of which is a closer aproximation
							var diffLast = abs(event.position.x - chrlen[i-1].x)
							var diffCurr = abs(event.position.x - chrlen[i].x)

							if (diffCurr < diffLast):
								currLetter = i
							else:
								currLetter = i-1
							break # no need to keep going
					else: # found the new line character, no match
						break

				if (notReached):
					currLetter = endLineChar
			else:
				var notReached = true
				var endLineChar = 0
				for i in range(chrlen.size()):
					endLineChar = i
					if (chrlen[i].y == 12):
						if (chrlen[i].x > event.position.x-18):
							notReached = false
							var diffLast = abs(event.position.x - chrlen[i-1].x)
							var diffCurr = abs(event.position.x - chrlen[i].x)

							if (diffCurr < diffLast):
								currLetter = i
							else:
								currLetter = i-1
							break

				if (notReached):
					currLetter = endLineChar
					
			# find out what marker we're inside
			var found = false
			for i in range(markerList.size()):
				if (markerList[i]["mark"] > currLetter):
					currMarker = i-1
					updateControls()
					found = true
					break
			# the last marker, the situation where the currLetter is bigger than all "mark"s
			if (!found):
					currMarker = markerList.size()-1
					updateControls()


			
			get_node("TextDrawer").update_text()
		# Getting rid of editable text
		else:
			textSelected = false
			get_node("TextDrawer/cursor").stop()
			get_node("TextDrawer/cursor").frame = 1
			
	if (event is InputEventKey and event.pressed):
		# controls like copying and clearing
		if (event.control):
			
			ctrlPressed = true

			match event.as_text().substr(8):
				# Go to the previous page
				"Comma":
					get_node("Page")._on_Previous_pressed()
				# Go to next page
				"Period":
					get_node("Page")._on_Next_pressed()
				"P":
					get_node("Page")._on_NextOp1_pressed()
				"Semicolon":
					get_node("Page")._on_NextOp2_pressed()
				"Slash":
					get_node("Page")._on_NextOp3_pressed()
				# Delete page
				"Shift+D":
					get_node("Page")._on_Delete_pressed()
				# (N)ew page
				"N":
					get_node("Page")._on_Create_pressed()
				# (S)ave file/object
				"S":
					get_node("File Select")._on_Save_pressed()
				# Play current text
				"Space":
					get_node("Play")._on_TextureButton_pressed()
				"R":
					get_node("File Select")._on_Save_pressed()
					triggerPreview()
				"Q":
					if (playingPreview):
						triggerPreview()
					

				# Insert/Remove marker
	
	if (event is InputEventKey and event.pressed and textSelected):
		
		# controls like copying and clearing
		if (event.control):

			match event.as_text().substr(8):
				# Copy all the text to the clipboard
				"C":
					OS.set_clipboard(currDia)
				
				# paste from clipboard
				"V":
					currDia = currDia.insert(currLetter, OS.get_clipboard())
					currLetter += OS.get_clipboard().length()
					totalLetters += OS.get_clipboard().length()
					get_node("TextDrawer").update_text()
				# delete everything written and clear all the markers
				#"Q":
				#	clearMarkers()
				#	get_node("TextDrawer").update_text()
				
				# Insert/Remove marker
				"M":

					# check for if we are trying to remove a marker or add one
					if (currLetter != 0):
						var remove = false
						for i in range(markerList.size()):
							# remove marker
							if (markerList[i]["mark"] == currLetter):
								markerList.remove(i)
								get_node("TextDrawer/Markers").get_child(get_node("TextDrawer/Markers").get_child_count()-1).queue_free()
								remove = true
								currMarker -= 1
								updateControls()
								break
						# add marker
						if (!remove):
							newMarker()
							currMarker += 1
							var markerSprite = Sprite.new()
							markerSprite.texture = load("marker.png")
							markerSprite.centered = false
							markerSprite.offset.y = -10
							markerSprite.position = get_node("TextDrawer/cursor").global_position
							get_node("TextDrawer/Markers").add_child(markerSprite)
							markerAdded = true
					get_node("TextDrawer").update_text()

		# for spanish characters
		elif (event.alt):
			match event.as_text()[4]:
				"N":
					currDia = currDia.insert(currLetter, "ñ")
					currLetter += 1
					totalLetters += 1
				"A":
					currDia = currDia.insert(currLetter, "á")
					currLetter += 1
					totalLetters += 1
				"I":
					currDia = currDia.insert(currLetter, "í")
					currLetter += 1
					totalLetters += 1
				"E":
					currDia = currDia.insert(currLetter, "é")
					currLetter += 1
					totalLetters += 1
				"O":
					currDia = currDia.insert(currLetter, "ó")
					currLetter += 1
					totalLetters += 1
				"U":
					currDia = currDia.insert(currLetter, "ú")
					currLetter += 1
					totalLetters += 1
				"S": # for slash (/), which is where the ? symbol is
					currDia = currDia.insert(currLetter, "¿")
					currLetter += 1
					totalLetters += 1
				"1":
					currDia = currDia.insert(currLetter, "¡")
					currLetter += 1
					totalLetters += 1
			get_node("TextDrawer").update_text()
					
		# normal Text
		else:
			match event.as_text():
			
				"Shift":
					pass
					
				"Control":
					pass
				"Alt":
					pass
			
				"Space":
					currDia = currDia.insert(currLetter, " ")
					currLetter += 1
					totalLetters += 1
					
					for i in markerList:
						# we normally like the shift forward, but now if it's on the 
						# initial marker, which should always have a mark of 0
						if (i["mark"] >= currLetter-1 && currLetter != 1):
							i["mark"] += 1
				
				"Enter":
					currDia = currDia.insert(currLetter, "\n")
					currLetter += 1
					totalLetters += 1
				
				"BackSpace":				
					if (currLetter > 0):
						currDia.erase(currLetter-1, 1)
						currLetter -= 1
						totalLetters -= 1
												
						for i in markerList:
							if (i["mark"] > currLetter):
								i["mark"] -= 1
								
						for i in range(1, markerList.size()):
							if (markerList[i]["mark"] == markerList[i-1]["mark"]):
								markerList.remove(i-1)
								# free a sprite
								get_node("TextDrawer/Markers").get_child(get_node("TextDrawer/Markers").get_child_count()-1).queue_free()
								currMarker -= 1
								updateControls()
								break # this interaction can only happen once an input

						
				"Up":
					# logic is copy-pasted from mouse inputs
					var lastPos = chrlen[currLetter]
					var notReached = true
					var endLineChar = 0
					for i in range(chrlen.size()):

						if (chrlen[i].y == 0):
							endLineChar = i
							if (chrlen[i].x > lastPos.x):
								notReached = false
								var diffLast = abs(lastPos.x - chrlen[i-1].x)
								var diffCurr = abs(lastPos.x - chrlen[i].x)

								if (diffCurr < diffLast):
									currLetter = i
								else:
									currLetter = i-1
								break
						else: # found the new line character, no match
							break
					if (notReached):
						currLetter = endLineChar
					
					var found = false
					for i in range(markerList.size()):
						if (markerList[i]["mark"] > currLetter):
							currMarker = i-1
							updateControls()
							found = true
							break
							
					if (!found):
						currMarker = markerList.size()-1
						updateControls()


						
				"Down":
					var notReached = true
					var endLineChar = 0
					var lastPos = chrlen[currLetter]
					for i in range(chrlen.size()):
						endLineChar = i
						if (chrlen[i].y == 12):
							if (chrlen[i].x > lastPos.x):
								notReached = false
								var diffLast = abs(lastPos.x - chrlen[i-1].x)
								var diffCurr = abs(lastPos.x - chrlen[i].x)

								if (diffCurr < diffLast):
									currLetter = i
								else:
									currLetter = i-1
								break

					if (notReached):
						currLetter = endLineChar
						
					var found = false
					for i in range(markerList.size()):
						if (markerList[i]["mark"] > currLetter):
							currMarker = i-1
							updateControls()
							found = true
							break
					# the last marker, the situation where the currLetter is bigger than all "mark"s
					if (!found):
							currMarker = markerList.size()-1
							updateControls()



				
				"Right":

					if (currLetter != totalLetters):
						currLetter += 1
						
						if (currMarker < markerList.size()-1):
							if (currLetter == markerList[currMarker+1]["mark"]):
								currMarker += 1
								updateControls()


					
				"Left":

					if (currLetter != 0):
						currLetter -= 1
						
						if (currLetter < markerList[currMarker]["mark"]):
							currMarker -= 1
							updateControls()


						
				# normal letters and numbers	
				_:
					#TODO: Make it so this only accepts a-Z and 1-9 and symbols, valid characters
					#FIX: USE AN ASCII OR UNICODE CHARACTERS IF STATEMENT TO CONSTRICT IT

					if (event.unicode >= 33 && event.unicode <= 127):
						currDia = currDia.insert(currLetter, PoolByteArray([event.unicode]).get_string_from_utf8())
						currLetter += 1
						totalLetters += 1
						
						for i in markerList:
							if (i["mark"] >= currLetter):
								i["mark"] += 1
						
			# Only update the text if we actually have new text to show
			# shortcuts don't count
			get_node("TextDrawer").update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# we only play the blinking on the cursor after enough inactivity
func _on_Timer_timeout():
	get_node("TextDrawer/cursor").frame = 0
	if (markerAdded):
		get_node("TextDrawer/cursor").frame = 1
		markerAdded = false
	get_node("TextDrawer/cursor").play()

# have it so when we go to the text box everything else is unfocused
func unfocus_all():
	get_node("Waves/Amp/HSlider").release_focus()
	get_node("Waves/Wave/HSlider").release_focus()
	get_node("Waves/Pi/HSlider").release_focus()
	get_node("Waves/Presets").release_focus()
	get_node("Waves/Save").release_focus()
	get_node("Color/Main/LineEdit").release_focus()
	get_node("Play/TextureButton").release_focus()
	get_node("Speed/Save").release_focus()
	get_node("Speed/Chars/HSlider").release_focus()
	get_node("Speed/Speed/HSlider").release_focus()
	get_node("Speed/Sounds/TextureButton").release_focus()
	get_node("Speed/Sounds/Add").release_focus()
	get_node("Page/Create").release_focus()
	get_node("Page/Delete").release_focus()
	get_node("Page/Next").release_focus()
	get_node("Page/Previous").release_focus()
	get_node("Name box/TextEdit").release_focus()
	get_node("Options/Option1").release_focus()
	get_node("Options/Option2").release_focus()
	get_node("Options/Option3").release_focus()
	get_node("Options/Option1/CreateOp1").release_focus()
	get_node("Options/Option1/NextOp1").release_focus()
	get_node("Options/Option2").release_focus()
	get_node("Options/Option2/CreateOp2").release_focus()
	get_node("Options/Option2/NextOp2").release_focus()
	get_node("Options/Option3").release_focus()
	get_node("Options/Option3/CreateOp3").release_focus()
	get_node("Options/Option3/NextOp3").release_focus()
	get_node("File Select/CurrentFile").release_focus()
	get_node("File Select/Save").release_focus()
	get_node("File Select/New").release_focus()
	get_node("Box Controls/Narration").release_focus()
	get_node("Box Controls/Centered").release_focus()
	get_node("Box Controls/Shock").release_focus()
	get_node("Box Controls/Dim").release_focus()
	get_node("Box Controls/BoxCutoff").release_focus()
	get_node("Box Controls/Prompt").release_focus()
	get_node("Note/Button").release_focus()
	get_node("Global Preset/OptionButton").release_focus()
	get_node("Global Preset/Save").release_focus()
	get_node("Sfx/SoundList").release_focus()
	get_node("Picture/Images").release_focus()
	get_node("Object/CurrentObject").release_focus()
	get_node("Object/New").release_focus()
	get_node("Object/Delete").release_focus()
	get_node("File Select/CurrentFile").release_focus()
	get_node("File Select/Save").release_focus()
	get_node("File Select/New").release_focus()
	get_node("Portraits").releaseFocus()
	get_node("Music/Songs").release_focus()
	get_node("Box Controls/Narration/Clear Narration").release_focus()
	get_node("Box Controls/Narration/Clear Normal").release_focus()
	get_node("Box Controls/Narration/Continue Normal").release_focus()
	get_node("BG/BG").release_focus()

func newMarker():
	var marker = {
		"mark": currLetter,
		"pi": get_node("Waves/Pi/HSlider").value,
		"wave": get_node("Waves/Wave/HSlider").value,
		"amp": get_node("Waves/Amp/HSlider").value,
		"color": get_node("Color/Main/ColorRect").color.to_html(false),
		"speed": get_node("Speed/Speed/HSlider").value,
		"chars": get_node("Speed/Chars/HSlider").value,
		"sound": get_node("Speed/Sounds/Add").get_item_text(get_node("Speed/Sounds/Add").get_selected_id()),
		"pause": get_node("Delay/Main/HSlider").value,
		"portraits": get_node("Portraits").getPortraitData(),
		"shock": get_node("Box Controls").shocked,
		"dim": get_node("Box Controls").dimmed,
		"prompt": get_node("Box Controls").prompted,
		"sfx": get_node("Sfx").soundFx,
		"pic": get_node("Picture").image,
		"music": get_node("Music").song
		
	}
	
	newMarkerValueCheck(marker, "pi", get_node("Waves/Pi/HSlider").value, 1)
	newMarkerValueCheck(marker, "wave", get_node("Waves/Wave/HSlider").value, 0)
	newMarkerValueCheck(marker, "amp", get_node("Waves/Amp/HSlider").value, 0)
	newMarkerValueCheck(marker, "color", get_node("Color/Main/ColorRect").color.to_html(false), Color("ffffff").to_html(false))
	newMarkerValueCheck(marker, "speed", get_node("Speed/Speed/HSlider").value, 0.01)
	newMarkerValueCheck(marker, "chars", get_node("Speed/Chars/HSlider").value, 1)
	newMarkerValueCheck(marker, "pause", get_node("Delay/Main/HSlider").value, 0)
	newMarkerValueCheck(marker, "shock", get_node("Box Controls").shocked, false)
	newMarkerValueCheck(marker, "dim", get_node("Box Controls").dimmed, false)
	newMarkerValueCheck(marker, "prompt", get_node("Box Controls").prompted, false)
	newMarkerValueCheck(marker, "sfx", get_node("Sfx").soundFx, "None")
	newMarkerValueCheck(marker, "pic", get_node("Picture").image, "None")
	newMarkerValueCheck(marker, "music", get_node("Music").song, "N/A")
	
	
	
	
	# we need to add it in sorted by mark, otherwise it will iterate incorrectly
	var foundSpot = false
	for i in range(markerList.size()):
		if (markerList[i]["mark"] > currLetter):
			markerList.insert(i, marker)
			foundSpot = true
			break
	if (!foundSpot):
			markerList.append(marker)



func newMarkerValueCheck(dict, key, value, default):
	if (value != default):
		dict[key] = value
	else:
		dict.erase(key)

# reset all markers and initialize a new one
func clearMarkers():
	
	for i in range(get_node("TextDrawer/Markers").get_child_count()):
		get_node("TextDrawer/Markers").get_child(i).queue_free()
	currDia = ""
	currMarker = 0
	currLetter = 0
	totalLetters = 0
	markerList.clear()
	newMarker()


func updateMarker():
	# hacky if statement, but makes it so that things are only updating marker values when we
	# are interacting with them above, otherwise this code will update whenever the values on the
	# change with updateControls, and we don't want that
	if (!textSelected and !get_node("Page").buttonPressed):
		markerValueCheck("pi", get_node("Waves/Pi/HSlider").value, 1)
		markerValueCheck("wave", get_node("Waves/Wave/HSlider").value, 0)
		markerValueCheck("amp", get_node("Waves/Amp/HSlider").value, 0)
		markerValueCheck("color", get_node("Color/Main/ColorRect").color.to_html(false), Color("ffffff").to_html(false))
		markerValueCheck("speed", get_node("Speed/Speed/HSlider").value, 0.01)
		markerValueCheck("chars", get_node("Speed/Chars/HSlider").value, 1)
		markerList[currMarker]["sound"] = get_node("Speed/Sounds/Add").get_item_text(get_node("Speed/Sounds/Add").get_selected_id())
		
		markerValueCheck("pause", get_node("Delay/Main/HSlider").value, 0)
		
		markerList[currMarker]["portraits"] = get_node("Portraits").getPortraitData()
		#print(get_node("Portraits").getPortraitData())
		
		markerValueCheck("shock", get_node("Box Controls").shocked, false)
		markerValueCheck("dim", get_node("Box Controls").dimmed, false)
		markerValueCheck("prompt", get_node("Box Controls").prompted, false)
		markerValueCheck("sfx", get_node("Sfx").soundFx, "None")
		markerValueCheck("pic", get_node("Picture").image, "None")
		markerValueCheck("music", get_node("Music").song, "N/A")
		
		for i in markerList:
			print(i.portraits)
		#markerList[currMarker]["pi"] = get_node("Waves/Pi/HSlider").value if get_node("Waves/Pi/HSlider").value > 1 else markerList[currMarker].erase("pi")

		

# Used to dynamically remove and add key/values to the dictionary to keep files
# smaller
func markerValueCheck(key, value, default):
	if (value != default):
		markerList[currMarker][key] = value
	else:
		markerList[currMarker].erase(key)
# When reading from the settings, this updates the controls
func updateControls():

	get_node("Waves/Pi/HSlider").value = markerList[currMarker]["pi"] if markerList[currMarker].has("pi") else 1
	get_node("Waves/Wave/HSlider").value = markerList[currMarker]["wave"] if markerList[currMarker].has("wave") else 0
	get_node("Waves/Amp/HSlider").value = markerList[currMarker]["amp"] if markerList[currMarker].has("amp") else 0
	get_node("Color/Main/LineEdit").text = str(Color(markerList[currMarker]["color"]).to_html(false)) if markerList[currMarker].has("color") else str(Color("ffffff").to_html(false))
	get_node("Color/Main/ColorRect").color = Color(get_node("Color/Main/LineEdit").text)


	get_node("Speed/Speed/HSlider").value = markerList[currMarker]["speed"] if markerList[currMarker].has("speed") else 0.01
	get_node("Speed/Chars/HSlider").value = markerList[currMarker]["chars"] if markerList[currMarker].has("chars") else 1
	get_node("Delay/Main/HSlider").value = markerList[currMarker]["pause"] if markerList[currMarker].has("pause") else 0

	# Select the sound
	var id = 0
	while (get_node("Speed/Sounds/Add").get_item_text(id) != ""):
		if (get_node("Speed/Sounds/Add").get_item_text(id) == markerList[currMarker]["sound"]):
			get_node("Speed/Sounds/Add").select(id)
			#var currSound = get_node("Sounds/Add").get_item_text(get_node("Sounds/Add").get_selected_id())
			#get_node("Sound").stream = load("sounds/" + currSound + ".wav")
			break
		id += 1
		
	get_node("Box Controls").updateMarkerControls(
		markerList[currMarker]["dim"] if markerList[currMarker].has("dim") else false,
		markerList[currMarker]["shock"] if markerList[currMarker].has("shock") else false,
		markerList[currMarker]["prompt"] if markerList[currMarker].has("prompt") else false
	)

	get_node("Portraits").updateAllPortraits(markerList[currMarker]["portraits"])
	get_node("Sfx").updateControls(markerList[currMarker]["sfx"] if markerList[currMarker].has("sfx") else "None")
	get_node("Picture").updateControls(markerList[currMarker]["pic"] if markerList[currMarker].has("pic") else "None")
	get_node("Music").updateControls(markerList[currMarker]["music"] if markerList[currMarker].has("music") else "N/A")

func triggerPreview(init=false):
	if (get_node_or_null("PreviewContainer") == null):
		textSelected = false
		playingPreview = true
		get_node("TextDrawer/cursor").stop()
		get_node("TextDrawer/cursor").frame = 1
		var loadPreview = preload("res://Text Box Preview/PreviewContainer.tscn").instance()
		loadPreview.loadPreview(
			"Dialogue/" + get_node("File Select/CurrentFile").getCurrentFile() + ".json",
			get_node("Object").getCurrentObject(),
			get_node("Page").currentPage.name
			)
		add_child(loadPreview)
	else:
		get_node("PreviewContainer").queue_free()
		playingPreview = false
		textSelected = true
