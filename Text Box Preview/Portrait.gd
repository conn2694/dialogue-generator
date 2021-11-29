extends Node2D

const NUM_POSITIONS = 32
const PORTRAIT_SIZE = 192
const PORTRAIT_RANGE = 120 # how much we can overlap
var arrivalPosition = 0
var atLocation = true
var travellingFrames = 0
var dir = 0
var sprite
var oldPosition = -PORTRAIT_RANGE
var previousFace = "N/A"
var previousLeaving = ""
# this is the saved position from the json, oldPosition is the actual coordinates
var previousPosition = 0
var currentlyDimmed = false
var fullyExited = false

func _ready():
	
	sprite = get_node("Sprite")


# for right when the character comes in
func initialReaction(portraitData):
	# shock
	shock(portraitData)
	# dim
	if (portraitData.has("dimmed")):
		dim()
	
func updatePortrait(portraitData):
	
	# New Character Entering scene
	var entering = false
	# If a character is suppose to be on screen
	if (portraitData.has("character")):
		# Entering frame with new character
		if (portraitData.has("enterType")):
			# if we are entering with a new character, but first are leaving with an old one
			entering = true
				
			enterScene(portraitData)
			updateSprite(portraitData)
		
		
		# Just moving around the frame
		elif (portraitData.position != previousPosition):

			atLocation = false
			arrivalPosition = convertToScreenPosition(portraitData.position)
			travellingFrames = 0
			# Moving left or right
			if (portraitData.position > previousPosition):
				dir = 1
			else:
				dir = -1
			previousPosition = portraitData.position
			interpolateToPosition(oldPosition, arrivalPosition, portraitData)
		
		# Leaving frame
#		if (portraitData.has("leaveType") && !entering):
#
#			exitScene(portraitData)
#			get_node("Sprite").texture = load("res://Sprites/General/Dialogue/Portraits/" + 
#				portraitData.character + "/" + 
#				portraitData.face)
		
		# The face changing
		if (portraitData.face != previousFace && !entering):
			updateSprite(portraitData)
			previousFace = portraitData.face
				

		
		

	
	
		
	# flip or not
	get_node("Sprite").flip_h = portraitData.has("flipped")
	
	#layer
	get_node("Sprite").z_index = portraitData.layer if portraitData.has("layer") else 0
	
	# shock
	shock(portraitData)
	
	# dimming and undimming
	# entering dimmed state
	if (!currentlyDimmed && portraitData.has("dimmed")):
		dim()
	# leaving dimmed state
	elif (currentlyDimmed && !portraitData.has("dimmed")):
		undim()
		

	
	
func enterScene(portraitData):

	if (portraitData.empty()):
		return
	
	sprite.position = Vector2(1000, 1000)
	# flip or not
	get_node("Sprite").flip_h = portraitData.has("flipped")
	
	#layer
	get_node("Sprite").z_index = portraitData.layer if portraitData.has("layer") else 0
	
	travellingFrames = 0

	
	if (portraitData.has("enterType")):
		if (portraitData.enterType == "left"):
			#get_node("Enter").play("Enter Left")
			oldPosition = 0 - (PORTRAIT_SIZE*0.5)
			arrivalPosition = convertToScreenPosition(portraitData.position)
			atLocation = false
			dir = 1
			interpolateToPosition(oldPosition, arrivalPosition, portraitData)

			
			
		elif (portraitData.enterType == "right"):
			#get_node("Enter").play("Enter Right")

			oldPosition = get_viewport_rect().size.x + (PORTRAIT_SIZE*0.5)
			arrivalPosition = convertToScreenPosition(portraitData.position)
			atLocation = false
			dir = -1
			interpolateToPosition(oldPosition, arrivalPosition, portraitData)

	else:
		sprite.position = Vector2(convertToScreenPosition(portraitData.position), 192)
		oldPosition = sprite.position.x
		
	previousPosition = portraitData.position
	

# manually exiting a portrait from a scene with the json variables before
# the text box is done.
func exitScene(portraitData):
	
	if (portraitData.empty()):
		return
	
	if (portraitData.has("leaveType")):
		if (portraitData.leaveType == "left"):
			#get_node("Enter").play_backwards("Enter Left")
			arrivalPosition = 0 - (PORTRAIT_SIZE*0.5)
			atLocation = false
		elif (portraitData.leaveType == "right"):
			arrivalPosition = get_viewport_rect().size.x + (PORTRAIT_SIZE*0.5)
			atLocation = false
			#get_node("Enter").play_backwards("Enter Right")
	
		interpolateToPosition(convertToScreenPosition(portraitData.position), arrivalPosition, portraitData)
	
# For when we want to clear all of the portraits at the end of a box automatically
func exitBox(portraitData):
	
	if (portraitData.empty()):
		return
	
	if (self.name == "Lt 1" || self.name == "Lt 2"):
		arrivalPosition = 0 - (PORTRAIT_SIZE*0.5)
	elif (self.name == "Rt 1" || self.name == "Rt 2"):
		arrivalPosition = get_viewport_rect().size.x + (PORTRAIT_SIZE*0.5)
		
	if (portraitData.has("leaveType")):
		if (portraitData.leaveType == "left"):
			#get_node("Enter").play_backwards("Enter Left")
			arrivalPosition = 0 - (PORTRAIT_SIZE*0.5)
			atLocation = false
		elif (portraitData.leaveType == "right"):
			arrivalPosition = get_viewport_rect().size.x + (PORTRAIT_SIZE*0.5)
			atLocation = false
			#get_node("Enter").play_backwards("Enter Right")
		
	interpolateToPosition(convertToScreenPosition(portraitData.position), arrivalPosition, portraitData)
	
		
func shock(portraitData):
	if (portraitData.has("shocked")):
		get_node("Shock").play("Shock")
		
func dim():
		get_node("Dim").play("Dim")
		currentlyDimmed = true
		
func undim():
		get_node("Dim").play_backwards("Dim")
		currentlyDimmed = false

# for figuring out if there is a character on screen
func characterActive(portraitData):
	return true if portraitData.has("character") else false

		
func convertToScreenPosition(value):
	
#	for i in range(NUM_POSITIONS+1):
#		var num = get_viewport_rect().size.x - PORTRAIT_SIZE + (PORTRAIT_RANGE) # evenly divide values with clamp
#		print('size: ', num )
#		num /= NUM_POSITIONS # make a set based on the number of divisions
#		num *= i # all the values
#		num += (PORTRAIT_SIZE - PORTRAIT_RANGE) * 0.5	# offset to center it
#		print(int(num))

	# We want the width of the screen, the size of two halves of a portrait so they'd
	# both be in frame, and then the range to stretch it out
	var num = get_viewport_rect().size.x - PORTRAIT_SIZE + (PORTRAIT_RANGE)
	# Segments out coordinates in sets of our numbered position, and then
	# multiplies the value to pick one of those positions
	num /= NUM_POSITIONS
	num *= value
	# because we shrink the size in the first part, we want to 
	# create an offset to center the array of positions
	# (if we get half of NUM_POSITION, we will get the center of the screen)
	num += (PORTRAIT_SIZE - PORTRAIT_RANGE) * 0.5	# offset to center it
	return int(num)
		
# Right now this exponentionally moves us up, find a way to have it go the other
# way instead
func interpolateToPosition(start, destination, portraitData):
	var tween = get_node("Tween")
	tween.interpolate_property(sprite, "position",
		Vector2(start, 192), Vector2(destination, 192), portraitData.speed if portraitData.has("speed") else 0.3,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	oldPosition = destination
	
# Used to get the speed of a portrait, if there's no character there is no speed
func getSpeed(portraitData):
	# No leaving is happening
	# PROBABLY DELETE THE OLDPOSITION COMPARISON 
	if (portraitData.empty() || !portraitData.has("leaveType")):
		return 0
	else:
		return portraitData.speed if portraitData.has("speed") else 0.3
	
func updateSprite(data):
	
	if (!data.has("face")):
		get_node("Sprite").texture = null
		return
		
	
	var tex = ImageTexture.new()
	var image = Image.new()
	var err = image.load(GLOBALS.PORTRAIT_PATH + "/" + data.character + "/" + data.face)
	if err != OK:
		print("didn't work")
	tex.create_from_image(image)
	get_node("Sprite").texture = tex
