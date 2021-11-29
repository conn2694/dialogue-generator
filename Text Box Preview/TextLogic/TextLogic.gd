extends Label

# TODO:

	# * NARRATOR: Get it so we can get files in with *filename* + Narrator.json
	#	This shouldn't be that hard, we can find a substring function that let's
	#	us use everything and then delete the last 4 characters and replace it with
	# 	Narrator.json
	
	# * NARRATOR: Test that the narrator can do a divert to a second 
	#	bit of dialogue with no issues (this should already work)
	
	# * NARRATOR: See if we can get a way to get the narrator text centered
	
	# * NARRATOR: It's clunky right now as we need to press a button to
	#	start the narrator, a button to close him, and a button to advance.
	#	It should be treated as one long thing, one press should get all the
	#	dialogue and then the narrator, and the next press should remove the
	#	narrator AND advance to the next dialogue. If we make the dialogue more
	#	paced out so you read it as it happens and there's more timing, than
	#	it should be one fluid thing, maybe a small timer before the narrator comes
	#	on if we want extra tension. but otherwise it'd be best to make the
	#	narrator come on after a button press to the dialogue it's responding too.
	#	
	# * NEW THING: Since I imagine we'll want text being more timing based.
	#	let's add a way to have the dialogue make small pauses through a timer
	#	who's length we can specify in an array in the json, along with a 
	#	parallel array for what character indexs we want the pauses happening on
	
	# * have a default amount of pause for punctuation if there is no speciffied
	#	characters we want to pause on, if we do have speccific characters with
	#	speccific times, we'll override that and instead use the custom thing.
	#	This means we don't need to waste time putting the same thing in the dialogue
	#	anytime we have a comma, but it also allows us to get more speciffic if we want to.
	
	# * it might be nice to have folders for all the different character portraits
	#	and we choose the folder based off the name json variable, meaning instead
	#	of having to do open files like "josh_happy" we can have the json name variable
	#	open the josh folder, and set the "happy.png" image in the josh folder as the 
	#	portrait to save us time, and it will help us keep things organized.
	
	# * To have pauses in the text, the logic for it is right under the _draw()
	#	function, we could have a variable that is set to 0 when we divert
	#	(we could honestly just reset it whenever all the characters are drawn
	#	on screen, so in the area with the (visibleCharacters >= allCharacters0
	#	bit. and then check from the json araay with the element of the
	#	variable we establish above, whenever we do this, we set the wait_time
	#	to our parallel array that has the times that we want to pause.
	#	when this happens we increase our variable by 1, to took for the next area
	#	(if it doesn't go away from the array, we could use a clamp from 0 to
	#	the size of the array -1). Not sure how to deal with when a character
	#	we want to pause on is skipped by skipBy, maybe check for if it's over
	#	and if so reset the visible characters to the one we were looking for
	#	and then go from there, but give it some more thought because it's late
	#	right now.
	
	
	
	# * make a special version of the text box for illustration cutscenes
	#	that allows us to multiple portaits on the screen, and is more geared
	#	towards animating cutscenes. We have play animations, and instead of
	#	waiting for the box to be closed, we can have a json variable that get's checked
	#	for in a divert, if this new text being diverted to has the variable, we
	#	will play the next animation. This will make it easy to program it in
	#	since I'll just be calling a function that tests for the variable.
	#	because of this we will be instancing the textbubbles in the illustration
	#	cutscene scene so we can use it's variables.
	
	#	for the cutscenes we'll have a special variable that is set to false
	#	every frame at the beginning, and then is true only for one frame
	#	when we are diverting, this bool will be used to alert our animation script
	#	that it's time to move to the next animation. This could also maybe be a
	#	number that goes up, which we will use to speciffy what animation to play.
	#	because of this, the animations in this will almost all be one shots.
	#	Also this cutscene dialog shouldn't have names probably, and should have
	#	the illuminated character be the one talking, while the other characters
	#	have some transparency to them, or dark tint to put them out of focus.
	#
	#	We'll make the cutscene in the middle of a bigger cutscene in the top down
	#	view. it will be instanced on top of it, probably called in the animation
	#	player. And this will take over while the top down waits every frame
	#	for it to be closed so it can resume down there.
	
	# 	We also want it to be able to have quick moments of not talking, like mark taking
	#	the wine. We want to start the animation during dialog, the waiter will come and stop
	#	next to mark, on the next animation it will pick up with mark taking the drink, but we
	#	don't want dialog for this section, so we can use our "interput" to simulate a pause
	#	with a box full of spaces (since they also are programmed to not make noise). This means
	#	josh can pick up the wine, and we can space it so he has just enough time to take
	#	the wine and hold it before the interupt then continues the dialogue. We can use
	#	the characters as time, just set the "skipby" to 1, have it at the default fast speed
	#	and just draw more spaces if we need more, since it doesn't matter if spaces
	#	go outside the box. 
	#
	#	Also we'll probably need to store these as indevidual scenes, but that's alright.
	#
	# * What if we talk to a shop keeper and we have options like >shop >talk >leave
	#	it'd be good to have dialogue options on the right side along with the left
	#	(player) side.
	#	NOTE: Or just have the shop guy show up on the left side since they
	#	are special characters anyways, it's not like Josh needs to have a conversation
	#	with them, he's just buying some stuff.
	
	# * add an little thing at the bottom right of the screen once all the
	#	text is displayed that prompts the user to press Z
	
	# * have other sound effects, one maybe for when dialogue boxes are done opening
	#	also one for when we move our curser up and down on our choices
	
	# * if you have time and feel like it maybe you can give putting in
	#	shocked questions where the curser moves on it's own and you have to
	#	time a button press, and after a couple of times it chooses one at random
	#	for you
	
	

# Change Log:
	
	# * Fixed the branching path selector so that it's now in a nice box, and
	#	has different style for if we have two or three options. we can use the
	#	constant QUESTION_BOX_POSITION to change the coordinate of the box, but
	#	it's in a really nice position right now I think.
	
	# * Added function exitAni(), which is a block of reusable code that plays an
	#	exit animation to make the transition from exiting to entering animations.
	#	It's pretty clean and pasts the textTest, but give it a bit more testing
	#	if you need to. We didn't do it with interupt because we want interupt to be
	#	be a more shocking thing. But get feedback, make a build of textTest
	#	for both Steph and Kago.
	
	# * Got it so that it only opens and closes when it first opens and closes,
	#	otherwise it just swaps the character and name if nessisary.
	#	Test this a bit more, we just implimented it and we want it fool proof.
	#	Test different combinations of having things with and without names,
	#	different names and faces, all sorts of stuff like that.
	
	# * realised there's no reason to speed up when there's no speed element,
	#	because the default is already the max speed. I also made the default
	#	values constants that are easy to change when we need to.
	# * NEW: Added skipBy to make text even speedier if we need, and also had it
	#	so we'll reset it to the last possible visible text if it goes over since
	#	we can now count by two's and three's and might go over it.
	# * got the "sound" variable working in json, now just say what sound
	#	you want to play as text scrolls, and it will do it
	# * restructured the _process for things like interuptions, much less
	#	cluttered with the if statements now
	# * initialized choicesDone to true so that it's not checking for arrow
	#	directions while there's no arrow on screen. Just a reminder to always
	#	attempt ALL of your possible inputs when testing to make sure nothing
	#	sneaky is happening.
	# * I now have smooth transitions with the names so they don't abruptly change to
	#	the next character before they leave the textbox. This was done with the
	#	animation player and the changeName function being called in the character
	#	entering animations
	# * character can now interupt themselves, and have started changing the name
	# * added shocked and just character slide in animations, added variables
	#	to the json like name and sameChar that are used to determine certain
	#	animations. Also fixed a placing of where the time is reset when you leave
	#	a frame. Used the json variables to have it so if the same character
	#	is talking on the next divert you can have it so the whole textbox doesn't need
	#	to leave, just your character sprite getting replaced
	# * Can now have two or more question boxes in a single dialogue scene
	# * FIXED ERROR ABOVE
	# * Added new font from Steph and implimented a variable textSpace in
	#	the drawing section that decides the spacing of text
	# * Implimented the amount of pi minipulation 
	# * Added the "interupt" feature to the text, allowing for characters to 
	#	interupt others while text is scrolling, also made a shortcut for accesing
	#	the animation node
	
# Json variables:
	#	divert: 	changes to the specified dialogue
	#	continue: 	will keep the text around and use to divert to add that text with its properties
	#	isEnd:		end of your dialogue, when this is closed, the whole object will free itself
	#	interupt:	this will end the dialogue right away without the player
	#				pressing anything, good for if josh is interupted by another character
	#	speed: 		speed of text
	#	amp: 		the waviness of the text
	#	wave: 		the wave modulator, the speed of radius
	#	pi:			the period of the sinwave
	#	face:		sprite portait to be on top of the text
	#	name:		name of character, used to determine name tag and
	#				if we need to play the animation of the new name tag coming in or not
	#	sameChar:	if this is in there we'll keep the textbox there and just
	#				go to the next bit of dialogue without playing the leaving
	#				animations
	#	open:		which direction the dialogue with open and close
	#	shock:		if the character should come in shocked
	#	option:		for linkpaths, the text used to represent the option
	#	linkPath:	where that option diverts too
	#	color:		3 element array holding the RGB values for the text
	#	initial:	where the dialogue will begin
	#	skipBy:		how many characters get drawn on screen after the timer stops
	#				This stops the 60fps from bottlenecking how fast the text can show up
	#	special:	bool that decides if we have the text centered for something with
	#				effects or for events like Josh getting something.

# Functions:
	# newText:		call before initializing it, this takes two arguments, the json
	#				file, and the part of the file you want to call text from
	# endPremature:	allows for the textbox to be prematurely freed for some
	#				situational parts of cutscenes.


var font = preload("res://Text Boxes/Aero.tres")
var dynamicFont = DynamicFont.new()


var waveModulator = 0	# the speed of the sine wave
var visibleText = 0		# the amount of visible characters at a time,
						# goes up whenever the timer resets
var allCharacters = 0	# gets all the characters of a string
var textSpeedUp = false
var pageText = {}		# Holds our json info
						
var currDialogue
var currChoices = []
var linkPath = false
var optionChoice = 0
var arrow = null
var questionBox = null
# change this to change the position of all the elements in the box
const QUESTION_BOX_POSITION = Vector2(35, 15)
var numOfNewLines = 0	# To figure out where to set the y-axis of our arrow
var storeNewLine = 0

# just in case we need the narrator scene we preload it
var narratorData = preload("res://Text Box Preview/Narrator.tscn")


						
	
var textBoxAniDone = false
var prematureEnd = false
var globalDrawText = ""		# used for our audio so that blank spaces don't have a sound to them

var textAni = null
var dialogueSet = ""		# takes the dialogue branch we put in newText and stores it so we can specify it all over
var fileSet = ""			# Takes the file name, mainly used for if we want to instance a narrator

var choicesDone = true		# hack vairable to make sure that once we choose an option that
							# we don't do the lines of code again, and lets us keep
							# linkPath for evaluation for once the animation finishes
var piAmount = 1			# set to 1 so that we don't ever get devision by 0
var nameBoxNode = null 
var drawAmp = 0.0
var waveSpeed

# if we want to start with a narration, we just 
# make the narration object.
var narrationActive = false
var globalTextInstance = null 	# for narration, lets us use weakref to check
								# if we can move on to the next thing.


## DEFAULT VALUES
const DEF_SPEED = 0.01
const DEF_WAVE_SPEED = 0.1
const DEF_PI = 8
const DEF_AMP = 0
const DEF_COLOR = Color(1, 1, 1)
const DEF_FACE = null
const DEF_NAME = null
const DEF_SKIP_BY = 1

var sameName = false
var sameFace = false

# decides wether to stop the player from walking, or if there are other
# settings like wanting the player to walk while interacting with it or
# something more speccific for cutscenes.
var textSetting = null
var currentMarker = 0

var delayed = false
var delayDone = false

var previousPortrait
var initBox = false

var pressedLeaving = false
var lastCharLocation = Vector2(0, 0)
var prompted = false
var holdDialogue = ""
var narrationDialogueFinished = true
var currentMarkers = {}
var optionSelect = false
var originalText = ""

enum NarrationType {WRITE=1, CONTINUE=2, CLEAR=3, CLEARNARR=4}

signal increaseNarrationText(value, allChars)
signal closeNarration
signal openNarration
var showOptions = false







func _ready():
	initBox = true
	textAni = get_node("../../CanvasLayer2/BottomBar/AnimationPlayer")
	nameBoxNode = get_node("../../CanvasLayer2/NameBox/Name")
	
	# decides if we should have text in the center or space it for two lines.

	if (currDialogue[1].has("centered") == true):
		self.rect_position = Vector2(15, 213)
	else:
		self.rect_position = Vector2(15, 205)
	
	dynamicFont.size = 16			# Size of our font	
	dynamicFont.font_data = font	# The font we established at the top
	
	#if (currDialogue == null):
	#	newText("res://test.json", "testingThisOut")
	

	# if there are characters on screen open one way, if not do it the other way
	if (get_node("../../CanvasLayer2/Portraits").charactersActive(currDialogue[1]["settings"][currentMarker].portraits)):
		nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else ""
		textAni.play("comingInFrameRight")
	else:
		textAni.play("comingInFrame")
		
	if (currDialogue[1].has("narrator")):
		get_node("Narrator/CanvasLayer/Label").newText(pageText, currDialogue)
		narrationActive = true
		narrationDialogueFinished = false
		
	get_node("Narrator/CanvasLayer/Label").connect("dialogueDone", self, "_on_Narration_Dialogue_Finished")

	get_node("Narrator/CanvasLayer/Label").connect("exited", self, "_on_Narration_Exited")
	get_node("Narrator/CanvasLayer/Label").connect("boxOpened", self, "_on_Narration_opened")

	

func _process(delta):
	

	drawAmp = currDialogue[1]["settings"][currentMarker].amp if currDialogue[1]["settings"][currentMarker].has("amp") else 0
	piAmount = currDialogue[1]["settings"][currentMarker].pi if currDialogue[1]["settings"][currentMarker].has("pi") else 1
	waveSpeed = currDialogue[1]["settings"][currentMarker].wave if currDialogue[1]["settings"][currentMarker].has("wave") else 0
	
	waveModulator += delta	# it needs to be added to every frame so that it doesn't reset to the beginning
	while (waveModulator > 200): #200 is arbitrary, just a decently big number that keeps overflow from happening
		waveModulator = 0

	update()
	


	
	# initial pi is 8, giving it  a smooth wavyness, make it 0 for dancing letters

		
	#print(waveSpeed)


		
	# tests every frame for the Z button, if all the characters are visible
	# our next block of text will be assigned in the other script, and
	# the visible text will go back down to 0 so it can start all over
	# if it hasn't, it will reveal all the characters
	#print(visibleText, " ", allCharacters)
	if (visibleText >= allCharacters && narrationDialogueFinished):
		#print("dialogueDone")

		
		if (Input.is_action_just_pressed("Action") && !linkPath && !currDialogue[1].has("interrupt")):
			
			# this means we have branching options
			if (currDialogue.size() > 2):

				linkPath = true
				choicesDone = false
				showOptions = true
				optionChoice = 0
				originalText = allCharacters
				# we start at 2 to skip the first bit of dialogue and it's properties
				# and instead use it to count our choices
				for i in range(2, currDialogue.size(), 1):
					currChoices.append(currDialogue[i].option)
					# the + 2 is for the two \t's for our options
					#allCharacters += (currDialogue[i].option.length() + 2)
					
				# for the one \n
				#allCharacters += 1
				# doing this lets us just see the options right away
				#visibleText = allCharacters
				
				storeNewLine = numOfNewLines
				#arrow = Sprite.new()
				#arrow.texture = load("res://Text Boxes/arrow.png")

				
				# Display and align options
				get_node("Options/Box").visible = false
				get_node("Options/Option 1").visible = false
				get_node("Options/Option 2").visible = false
				get_node("Options/Option 3").visible = false
				get_node("Options/Cursor").visible = false
				
				get_node("Options/Option 1").text = ""
				get_node("Options/Option 2").text = ""
				get_node("Options/Option 3").text = ""
				
				
				updateOptionSelect()


				

			
				# load, position and resize the textbox.
				#questionBox = Sprite.new()
				#questionBox.texture = load("res://Text Boxes/textBoxBlackBox.png")
				#questionBox.z_index = -1 # so that the text can show through

				# changes the scale and position of the box and the positon of the
				# arrow based on if there are two or three options.
				#if (currChoices.size() == 3):
					#questionBox.scale = Vector2(0.25, 0.80)
					#questionBox.position = Vector2(240, -58) + QUESTION_BOX_POSITION
				#	arrow.position = Vector2(5, (0 * 16 + 12)) + QUESTION_BOX_POSITION
				#elif (currChoices.size() == 2):
					#questionBox.scale = Vector2(0.25, 0.50)
					#questionBox.position = Vector2(240, -58) + QUESTION_BOX_POSITION + Vector2(0, 10)
				#	arrow.position = Vector2(5, (0 * 16 + 19)) + QUESTION_BOX_POSITION + Vector2(0, 10)

				#print(currChoices.size()) # use this to get smaller boxes for less answers

				
				# 10 for the padding on the screen so it fits next to our answers
				# storeNewLine to make sure it always is relative to the size
				# of the dialogue above
				# 16 for the character height
				# 12 for the patting on top 
#				if (currChoices.size() == 3):
#					arrow.position = Vector2(5, (storeNewLine * 16 + 12)) + QUESTION_BOX_POSITION
#				elif (currChoices.size() == 2):
#					arrow.position = Vector2(5, (storeNewLine * 16 + 19)) + QUESTION_BOX_POSITION

				#add_child(arrow)
				#add_child(questionBox)
				
			# divert to next page
			else:
			

				# normal divert to next page
				if (true):
					# The json version of going up a page, we divert to the next section of the json file
					if (currDialogue[1].divert != ""):
						
						# since we're clearing the screen, there's no reason to hold onto
						# any of the info from previous screen
						previousPortrait = currDialogue[1]["settings"][currentMarker].portraits
						get_node("PromptSound").play()
						
						# Since we know there is a next box, we can check if there's a narration to know if we should do anything
						if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("narrator")):
							visibleText = -1
							get_node("Narrator/CanvasLayer/Label").visibleText = -1
						else:
							if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("continueNormal")):
								narrationDialogueFinished = false
							else:
								visibleText = -1
							if (pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("clearNormal")):
								visibleText = -1
							if (pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("clearNarration")):
								get_node("Narrator/CanvasLayer/Label").visibleText = -1
						
	
		
						# exits the same way we opened from
	
						# if our next dialogue is the same character
						# if (currDialogue[1].has("sameChar")):
							
						#exitAni()
	
	
					# If it's the end of the dialogue box, we free the whole scene,
					# later on we will first have an animation play here with our box
					# so that it falls down and our character moves out of the window
					# and then freeing it. Also clears our json info
					else: 
						visibleText = -1
						pageText.clear()
						
						if (get_node("../../CanvasLayer2/Portraits").charactersActive(currDialogue[1]["settings"][currentMarker].portraits)):
							textAni.play("leavingFrameRight")
						else:
							textAni.play("leavingFrame")
						
						if (currDialogue[1].has("narrator")):
							get_node("Narrator/CanvasLayer/Label").closeBox()
							


						
		# choosing our options
		elif (!choicesDone):
			if (Input.is_action_just_pressed("Action")):
				choicesDone = true
				currChoices.clear()		# get rid of our choices to make room for more if we have them
				#arrow.queue_free()		# get rid of the arrow sprite
				#questionBox.queue_free()
				allCharacters = originalText
				visibleText = allCharacters
				# Display and align options
				get_node("Options/Box").visible = false
				get_node("Options/Option 1").visible = false
				get_node("Options/Option 2").visible = false
				get_node("Options/Option 3").visible = false
				get_node("Options/Cursor").visible = false
				
				get_node("Options/Option 1").text = ""
				get_node("Options/Option 2").text = ""
				get_node("Options/Option 3").text = ""
				
				linkPath = false
				#var oldName = currDialogue[1].name if currDialogue[1].has("name") else ""
				get_node("Select").play()
				
										# Since we know there is a next box, we can check if there's a narration to know if we should do anything
				if (!pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"][1].has("narrator")):
					visibleText = -1
					get_node("Narrator/CanvasLayer/Label").visibleText = -1
				else:
					if (!pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"][1]["narrator"].has("continueNormal")):
						narrationDialogueFinished = false
					else:
						visibleText = -1
					if (pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"][1]["narrator"].has("clearNormal")):
						visibleText = -1
					if (pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"][1]["narrator"].has("clearNarration")):
						get_node("Narrator/CanvasLayer/Label").visibleText = -1
				
				#currDialogue = pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"]
				#checkDelay()
				#get_node("../../CanvasLayer2/NameBox").updateName(currDialogue[1].name if currDialogue[1].has("name") else "", oldName)
						
				#get_node("textScroller").start()
				#print("currdia: ", currDialogue)
					

						
			elif (Input.is_action_just_pressed("Down") && currChoices.size() > 1):
				optionChoice += 1
				get_node("Options/Cursor").position.y += 14
				
				# wrap around when we try accessing an option higher than what we have
				if (optionChoice > currChoices.size() - 1):
					# original position
					if (currChoices.size() == 3):
						get_node("Options/Cursor").position.y = 73+2
					elif (currChoices.size() == 2):
						get_node("Options/Cursor").position.y = 87+2

					optionChoice = 0
				
			elif (Input.is_action_just_pressed("Up") && currChoices.size() > 1):
				optionChoice -= 1
				get_node("Options/Cursor").position.y -= 14
				
				# wraps around to the bottom
				if (optionChoice < 0):
					get_node("Options/Cursor").position.y = 101+2
					optionChoice = currChoices.size() - 1
					

			
		# one text box is replaced with another one with no input from the player
		# usually used to show a character interrupting another
		elif (currDialogue[1].has("interrupt")):

						
			if (currDialogue[1].divert != ""):
				# Since we know there is a next box, we can check if there's a narration to know if we should do anything
				if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("narrator")):
					visibleText = -1
					get_node("Narrator/CanvasLayer/Label").visibleText = -1
				else:
					if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("continueNormal")):
						narrationDialogueFinished = false
					else:
						visibleText = -1
					if (pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("clearNormal")):
						visibleText = -1
					if (pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1]["narrator"].has("clearNarration")):
						get_node("Narrator/CanvasLayer/Label").visibleText = -1
								
				# we don't play the sound when interrupting, just go right to the logic
				_on_PromptSound_finished()
			
			# interrupting to end the dialogue
			else: 
				visibleText = -1
				pageText.clear()
				
				if (get_node("../../CanvasLayer2/Portraits").charactersActive(currDialogue[1]["settings"][currentMarker].portraits)):
					textAni.play("leavingFrameRight")
				else:
					textAni.play("leavingFrame")
				
				if (currDialogue[1].has("narrator")):
					get_node("Narrator/CanvasLayer/Label").closeBox()


			
			
	
	elif (visibleText < allCharacters || !narrationDialogueFinished):	
		if (Input.is_action_pressed("Action")):
			textSpeedUp = true 
		else:
			textSpeedUp = false
		
		if (!prompted):
			turnOffPrompt()
		else:
			if (!narrationDialogueFinished):
				displayPrompt(true)
			else:
				displayPrompt()
			if (Input.is_action_pressed("Action")):
				prompted = false
				checkDelay()
				get_node("textScroller").start()
			
			

		
		



func _draw():

	# THIS IS WHERE OUR STUFF TO CHANGE WHERE THE PAUSED WOULD HAPPEN, have
	# it based on numbers for specified ones, have it based on punctuation
	# characters when nothing is speciffied. We'll need the variable
	# that holds the current dialogue text and put the visibleText-1 in for
	# array index.
#	if (visibleText == currDialogue[1]["settings"]):
#		#get_node("textScroller").wait_time = 1
#		pass
#	else:
#		get_node("textScroller").wait_time = currDialogue[1]["settings"].speed
#
#		# for if Z is being held
#		if (textSpeedUp && currDialogue[1].has("speed")):
#			get_node("textScroller").wait_time = currDialogue[1].speed * 0.33 

	# gets all of our characters, every frame we first reset to 0, and then add
	# all of our previous text if it's continued, and then add to it our current
	# dialogue
	# NOTE: this can possibly be done above whenever we divert so we don't have to do
	#		it every frame
	allCharacters = holdDialogue.length()
	
	
	var textBreak = 0
	var backToBeginning = 0	# used along with textBreak to give a new line
	# we declare and initialize these variables that will be menipulated in the for loop
	var drawColor = Color(1, 1, 1)	
	# gets all of the text, first from the previous text if it's continued,
	# and then from our current dialogue
	var drawText = ""
	var choicePosition = Vector2(0,0)
	var questionNumber = Vector2(0, 0)
	
	# we do this now so we don't need to do this check for every single i
	# in the for loop, determines where on the screen the text should show up
	# based on how many choices there are on the screen.
	if (currChoices.size() == 3):
		questionNumber = Vector2(200, -80) + QUESTION_BOX_POSITION
	elif (currChoices.size() == 2):
		questionNumber = Vector2(200, -63) + QUESTION_BOX_POSITION

	drawText += holdDialogue
	
	# used so that our colors don't effect the colors of the choices
	var beforeChoices = drawText.length()
	if (linkPath && showOptions):
					showOptions = false
					get_node("Options/Option 1").visible = true
					get_node("Options/Option 2").visible = true
					get_node("Options/Option 3").visible = true
					get_node("Options/Box").visible = true
					get_node("Options/Cursor").visible = true
					updateOptionSelect()
					
	globalDrawText = drawText

	var textSpace = 0

	numOfNewLines = 0
	var markIter = 0
	var markers = currentMarkers
	for i in range(visibleText):
			
		if (markIter != markers.size()-1):
			if (i >= markers[markIter+1]["mark"]):
				markIter += 1
				
		var waveSpeed = markers[markIter]["wave"] if markers[markIter].has("wave") else 0
		var charWaveSpeed = waveSpeed * waveModulator
		while (charWaveSpeed > PI*2):
			charWaveSpeed -= PI*2
				
		# backToBeginning is basically i, only thing making it different 
		# is that it resets to 0 when the new line happens
		backToBeginning += 1


		
		# For the choices, we use a white color and different coordinates so they
		# fit in the box
		if (i > beforeChoices):
			drawAmp = 0
			drawColor = Color(1, 1, 1)
			choicePosition = questionNumber	#position based on amount of choices
				
				
		
			
		# If certain characters are being drawn that are thinner, we 
		# subtrack a given amount in pixels from the location on the x-axis
		# the next characters will be
		if (i > 0):
			# i, l, and ' are very short, so we subtrack 4 pixels from following letters
			if (drawText[i-1] == 'i' || drawText[i-1] == 'l' || drawText[i-1] == '\'' || drawText[i-1] == 'í' || drawText[i-1] == '\"' || drawText[i-1] == '!' || drawText[i-1] == '.' || drawText[i-1] == ',' || drawText[i-1] == ';' || drawText[i-1] == '¡'):
				textSpace += 4
			# w and m are very big, so we add 1 pixel to the following letters
			elif (drawText[i-1] == 'w' || drawText[i-1] == 'm' || drawText[i-1] == 'M' || drawText[i-1] == 'W' || drawText[i-1] == 'O'):
				textSpace -= 2
				
			elif (drawText[i-1] == 'r' || drawText[i-1] == "j" || drawText[i-1] == ' ' || drawText[i-1] == 'c'):
				textSpace += 1	
				
			# NEW, add this to the in game script too
			elif (drawText[i-1] == '('):
				textSpace += 3
			
		# Since new line doesn't happen automatically, gotta do it ourselves
		if (drawText[i] == '\n'):
			numOfNewLines += 1 
			textBreak += 12
			backToBeginning = 0
			textSpace = 0	# since it's a new line we can reset our text spacing

			
		
		# Just PI makes the text dance
		var letterWidth
		var markAmp = markers[markIter]["amp"] if markers[markIter].has("amp") else 0
		var markPi = markers[markIter]["pi"] if markers[markIter].has("pi") else 1
		letterWidth = draw_char(dynamicFont, 
			Vector2(backToBeginning * (dynamicFont.size * 0.375) - textSpace + choicePosition.x,		# the font size keeps the spacing consistent for if you change the font size, back to beginning makes it so that when a break happens it goes back to the first x value
			markAmp * sin(i * PI/markPi + charWaveSpeed) + textBreak + choicePosition.y), # classic sin wave to do the waves, textBreak brings it down once \n happens
			drawText[i],	# Character drawn
			"a",	# Not sure what this does, but "a" seems to work just fine
			markers[markIter]["color"] if markers[markIter].has("color") else Color("ffffff"))		# The color of the character

		lastCharLocation = Vector2(letterWidth + backToBeginning * (dynamicFont.size * 0.375) - textSpace + choicePosition.x,		# the font size keeps the spacing consistent for if you change the font size, back to beginning makes it so that when a break happens it goes back to the first x value
			markAmp * sin(i * PI/markPi + charWaveSpeed) + textBreak + choicePosition.y)

func updateOptionSelect():
	
	get_node("Options/Option 1").rect_size = Vector2(0, 0)
	get_node("Options/Option 2").rect_size = Vector2(0, 0)
	get_node("Options/Option 3").rect_size = Vector2(0, 0)
		
	match currChoices.size():
		1:
			get_node("Options/Option 3").text = currChoices[0]
		2:
			get_node("Options/Option 2").text = currChoices[0]
			get_node("Options/Option 3").text = currChoices[1]
		3:
			get_node("Options/Option 1").text = currChoices[0]
			get_node("Options/Option 2").text = currChoices[1]
			get_node("Options/Option 3").text = currChoices[2]

	
	var biggestChoice = 0
	biggestChoice = max(get_node("Options/Option 1").rect_size.x, biggestChoice)
	biggestChoice = max(get_node("Options/Option 2").rect_size.x, biggestChoice)
	biggestChoice = max(get_node("Options/Option 3").rect_size.x, biggestChoice)

	
	get_node("Options/Option 1").rect_position = Vector2(124-biggestChoice, 73)
	get_node("Options/Option 2").rect_position = Vector2(124-biggestChoice, 87)
	get_node("Options/Option 3").rect_position = Vector2(124-biggestChoice, 101)
	
	if (currChoices.size() == 3):
		get_node("Options/Box").rect_size.y = 49
		get_node("Options/Box").rect_position.y = 70
		get_node("Options/Cursor").position = Vector2(124-biggestChoice-10, 73+3)	# centers it in the way we want

	elif (currChoices.size() == 2):
		get_node("Options/Box").rect_size.y = 35
		get_node("Options/Box").rect_position.y = 84
		get_node("Options/Cursor").position = Vector2(124-biggestChoice-10, 87+3)	# centers it in the way we want

	elif (currChoices.size() == 1):
		get_node("Options/Box").rect_size.y = 21
		get_node("Options/Box").rect_position.y = 98
		get_node("Options/Cursor").position = Vector2(124-biggestChoice-10, 101+3)	# centers it in the way we want

	
	get_node("Options/Box").rect_size.x = biggestChoice + 24
	get_node("Options/Box").rect_position.x = 128-biggestChoice - 21


func displayPrompt(narrator = false):
	get_node("Prompt").visible = true
#	get_node("Prompt").position = lastCharLocation
#	get_node("Prompt").position += Vector2(5, -10)
	if (narrator):
		get_node("Prompt").global_position = Vector2(336-14, 32-12)
	else:
		get_node("Prompt").global_position = Vector2(336-14, 224-12)
	get_node("Prompt").play("Prompt")
	
func turnOffPrompt():
	get_node("Prompt").visible = false
	
	

func newText(textFile, textPath, page):
	fileSet = textFile
	dialogueSet = textPath
	# opens our json file for reading
	var file = File.new()
	file.open(textFile, File.READ)
	

	pageText = parse_json(file.get_as_text())
	
	# since we just parsed the json into memory, there's no reason to keep it open
	file.close()
	
	# the textpath is where we want our dialogue starting, the ["data"] and ["content"] 
	# just need to be there to get us to where we need, allowing us to just use
	# currDialogue[0] for the dialogue and currDialogue[1] for all it's properties
	if (page == ""):
		currDialogue = pageText["data"][textPath][pageText["data"][textPath]["initial"]]["content"]
	else:
		currDialogue = pageText["data"][textPath][page]["content"]
	if (currDialogue[0].length() < 1): currDialogue[0] = " "
	currentMarkers = currDialogue[1]["settings"]
	
	# we aren't starting with normal dialogue if we start off with narrator
	if (!currDialogue[1].has("narrator")):
		holdDialogue = currDialogue[0].c_unescape()
	else:
		holdDialogue = ""

		

# This will now be where we check for markers changing, text speed changing, pauses, animation changes
# etc
func _on_Timer_timeout():
	

	var markerChange = false
	# for when we want to update the marker, we have to make sure we can skip one
	# if for instance, we have a 1 character marker but are jumping by 3 characters
	if (currDialogue[1]["settings"].size() > 1):
		while (currentMarker < currDialogue[1]["settings"].size()-1 && visibleText >= currDialogue[1]["settings"][currentMarker+1].mark):
			currentMarker += 1
			markerChange = true
			
		# This accounts for if there's a narration, since it stays at 0 
		# when narration isn't active, it shouldn't ever go through
		var narrText = get_node("Narrator/CanvasLayer/Label").visibleText
		while (currentMarker < currDialogue[1]["settings"].size()-1 && narrText >= currDialogue[1]["settings"][currentMarker+1].mark):
			currentMarker += 1
			markerChange = true
			
	# if there is a new marker, this will be overwritten by the pause
	get_node("textScroller").wait_time = currDialogue[1]["settings"][currentMarker].speed if currDialogue[1]["settings"][currentMarker].has("speed") else 0.01
	
	# use this to update all our factors, the sound, the portraits, dimmed or shocked
	if (markerChange):
		# EXIT HERE
		if (currentMarker < currDialogue[1]["settings"].size()-1):
			get_node("../../CanvasLayer2/Portraits").checkLeavePortraits(currDialogue[1]["settings"][currentMarker].portraits)
		
		
		if (currDialogue[1]["settings"][currentMarker].has("prompt")):
			prompted = true
		else:
			checkDelay() # check to see if we have a delay
		
	# 3 This is for when a delay timeout finishes, we just want to update markers 
	# tell the program it can update the text normally by setting delayed = false
	if (delayDone):
		if (currentMarker > 0):		# don't do these on the first marker, previousPortrait should still contain last pages portraits

			previousPortrait = currDialogue[1]["settings"][currentMarker-1].portraits
			updateMarkers()
		if (initBox):	# if there was a delay in the initial page (rare)
			initialActions()
		delayed = false
		delayDone = false
		
	# 4 This will go through once a delay is finished or there is no delay at all
	if (!delayed && !prompted):
		# ammount of characters we're adding
		if (narrationActive && !currDialogue[1]["narrator"].has("continueNormal")):
			emit_signal("increaseNarrationText", currDialogue[1]["settings"][currentMarker].chars if currDialogue[1]["settings"][currentMarker].has("chars") else 1, allCharacters)
			var narrText = get_node("Narrator/CanvasLayer/Label").visibleText
			var narrDia = get_node("Narrator/CanvasLayer/Label").getCurrentDialogue()
			var narrAllChars = get_node("Narrator/CanvasLayer/Label").getAllChars()
			var newChars = currDialogue[1]["settings"][currentMarker].chars if currDialogue[1]["settings"][currentMarker].has("chars") else 1	
			# if the new character isn't a space or newline, 
			# and if we're displaying more than one char. play the beep
			if (narrDia[narrText-1] != " " &&
				narrDia[narrText-1] != "\n" ||
				newChars > 1):
				if (!get_node("AudioStreamPlayer").playing && !get_node("PromptSound").playing):	
					get_node("AudioStreamPlayer").play(0.0)
					
			# Eventually get this to just stop the timer all together
			if (narrText >= narrAllChars):
				narrText = narrAllChars
				get_node("textScroller").stop()
				if (!currDialogue[1].has("interrupt")):
					displayPrompt(true)
			else:
				get_node("textScroller").start()
		else:	
			visibleText += currDialogue[1]["settings"][currentMarker].chars if currDialogue[1]["settings"][currentMarker].has("chars") else 1
			visibleText = clamp(visibleText, 0, allCharacters)
			var newChars = currDialogue[1]["settings"][currentMarker].chars if currDialogue[1]["settings"][currentMarker].has("chars") else 1
		
			# if the new character isn't a space or newline, 
			# and if we're displaying more than one char. play the beep
			if (globalDrawText[visibleText-1] != " " && 
				globalDrawText[visibleText-1] != "\n" || 
				newChars > 1):
				if (!get_node("AudioStreamPlayer").playing && !get_node("PromptSound").playing):	
					get_node("AudioStreamPlayer").play(0.0)
					
			# Eventually get this to just stop the timer all together
			if (visibleText >= allCharacters):
				visibleText = allCharacters
				get_node("textScroller").stop()
				if (!currDialogue[1].has("interrupt")):
					displayPrompt()
			else:
				get_node("textScroller").start()
		
	# 2 a hack to make sure we call the timer again after the delay has finished, and also set
	# it so it will go back to normal behavior on the next timeout
	if (delayed):
		delayDone = true
		get_node("textScroller").start()
	# 2
	

func _on_Narration_Dialogue_Finished():
	narrationDialogueFinished = true

# For when we reach a new marker or page and need to update the settings
func updateMarkers():

		# update our portraits
		get_node("../../CanvasLayer2/Portraits").updatePortraits(
			currDialogue[1]["settings"][currentMarker].portraits
		)
		# adjust dim
		get_node("../../CanvasLayer2/Dim").updateDim(
			currDialogue[1]["settings"][currentMarker].has("dim")
		)
		# shock
		if (currDialogue[1]["settings"][currentMarker].has("shock")):
			get_node("../../CanvasLayer2/Shock/AnimationPlayer").play("Shock")
		
		# update beep sound
		var audioSource = null
		if (currDialogue[1]["settings"][currentMarker].has("sound")):
			audioSource = load("res://sounds/" + currDialogue[1]["settings"][currentMarker].sound + ".wav")
		get_node("AudioStreamPlayer").stream = audioSource

		
		# update sfx
		if (currDialogue[1]["settings"][currentMarker].has("sfx")):
			get_node("../../CanvasLayer2/Sfx").stream = load("res://Sound/SFX/Text Box/Sounds/" + currDialogue[1]["settings"][currentMarker].sfx + ".wav")
			get_node("../../CanvasLayer2/Sfx").play(0.0)
		
		
func checkDelay():
	# we want to override with a pause if there is a pause
	if (currDialogue[1]["settings"][currentMarker].has("pause")):
		delayed = true
		delayDone = false
		get_node("textScroller").wait_time = currDialogue[1]["settings"][currentMarker].pause
		get_node("textScroller").start()
	else:
		updateMarkers()
		
	


func endPremature():
	get_node("textScroller").stop()
	visibleText = 0
	prematureEnd = true
	if (get_node("../../CanvasLayer2/Portraits").charactersActive(currDialogue[1]["settings"][currentMarker].portraits)):
		textAni.play("leavingFrameRight")
	else:
		textAni.play("leavingFrame")
	
# load up the initial portrait textures
func loadPortraits():
	get_node("../../CanvasLayer2/Portraits").loadTextures(currDialogue[1]["settings"][currentMarker]["portraits"])
	
# slides all the portraits in
func enterPortraits():
	get_node("../../CanvasLayer2/Portraits").enterPortraits(currDialogue[1]["settings"][currentMarker]["portraits"])
	
	#this is the time to dim the scene if it should be initially
	if (currDialogue[1]["settings"][currentMarker].has("dim")):
		get_node("../../CanvasLayer2/Dim").startDim()
		
# slides all the portraits out
func exitPortraits():
	get_node("../../CanvasLayer2/Portraits").exitPortraits(currDialogue[1]["settings"][currentMarker]["portraits"])
	
	#this is the time to undim the scene if it should be initially
	if (currDialogue[1]["settings"][currentMarker].has("dim")):
		get_node("../../CanvasLayer2/Dim").endDim()
		
		
		
# this is for when characters slide in from interrupts or continues, doesn't
# change the name until the namebox is hidden in the section of animation
func changeName():
	nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else ""

# misleading name, this is called the exact moment everything has entered the scene
func comingIntoFrame():

	# we want to override with a pause if there is a pause
	if (currDialogue[1]["settings"][currentMarker].has("pause")):
		delayed = true
		delayDone = false
		get_node("textScroller").wait_time = currDialogue[1]["settings"][currentMarker].pause
	else:
		initialActions()
	get_node("textScroller").start()

# When the first box comes in, this is used to organize what should happen after the end of the 
# delay of comingIntoFrame
func initialActions():
	# the initial reaction of all the characters
	get_node("../../CanvasLayer2/Portraits").initReactions(currDialogue[1]["settings"][currentMarker]["portraits"])
	# if there's a shock, play the effect here
	if (currDialogue[1]["settings"][currentMarker].has("shock")):
		get_node("../../CanvasLayer2/Shock/AnimationPlayer").play("Shock")
		
	# update beep sound
	var audioSource = null
	if (currDialogue[1]["settings"][currentMarker].has("sound")):
		audioSource = load("res://sounds/" + currDialogue[1]["settings"][currentMarker].sound + ".wav")
	get_node("AudioStreamPlayer").stream = audioSource

	
	# update sfx
	if (currDialogue[1]["settings"][currentMarker].has("sfx")):
		get_node("../../CanvasLayer2/Sfx").stream = load("res://Sound/SFX/Text Box/Sounds/" + currDialogue[1]["settings"][currentMarker].sfx + ".wav")
		get_node("../../CanvasLayer2/Sfx").play(0.0)
	
	initBox = false

	
	

# we are freeing the box
func leavingFrame():
	

	# exiting the last box
#	if(currDialogue[1].divert == "" || prematureEnd):
		
		if (textSetting == 0):
			pass
		
		get_node("../../..").queue_free()


	
#	elif (currDialogue[1].has("divert") || linkPath):
#		# wait to start the timer until the comingIntoFrame happens
#		# For if we are moving to a new thing of dialogue
#		if (currDialogue[1].has("divert") && !linkPath):
#
#			currDialogue = pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"]
#			get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
#			# decides if we should have text in the center or space it for two lines.
#			if (currDialogue[1].has("special")):
#				self.rect_position = Vector2(15, 213)
#			else:
#				self.rect_position = Vector2(15, 205)
#
#		# for after choosing your choice in a linkpath
#		elif (linkPath):
#			# before it was only showing optionChoice = 0 because it would put 
#			# linkpath as false before the choices went out of frame, putting it here fixes it
#			linkPath = false
#			currDialogue = pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkPath"]]["content"]
#
#		# set new speed to the new dialogue, along with the name and making sure there's no visible text
#		get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
#		nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else " "
#		visibleText = 0		# This might be redundent, since the update already makes the visibleText = 0 when we advance the dialogue
#
#
#		# After changing the dialogue, let's open our new dialogue here
#		# USE THIS FOR THE SHOCKED REACTION ANIMATION and the animations
#		# for new dialogue from the same character
#		if (sameName):
#			if (sameFace):
#				comingIntoFrame()
#			else:
#				if (currDialogue[1].has("shock")):
#					textAni.play("shockJustCharacterSlideRight")
#				else:
#					textAni.play("justCharacterSlideRight")
#
#
#		else:
#
#			if (currDialogue[1].has("shock")):
#					textAni.play("shockCharacterSlideRight")
#			else:
#				if (currDialogue[1].has("name")):
#					textAni.play("characterSlideRight")
#
#				else:
#					comingIntoFrame()
#
#	sameName = false
#	sameFace = false
	
	
func exitAni():
	# if we our current dialogue and the one we are diverting to both have
	# name, then we compare the name to figure out if it is the same one or not
	if (currDialogue[1].has("name") && pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("name")):

		if (currDialogue[1].name == pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].name):
			# do all the stuff we normally do in our leavingFrame function
			sameName = true

			# if we use the same face, no need to play any animations.
			if (currDialogue[1].face == pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].face):
				textAni.play("JustDelay")
				sameFace = true

			else:
				textAni.play("CharLeaving")
			
		# both have a name but not the same character
		else:
			# so put them both back
			textAni.play("CharAndBoxLeaving")
	# Either of them don't have a name.
	else:
		# we don't want to be putting name back if we don't even have a name
		# on screen, so if we do have a name on our next one, let's get rid 
		# of the ones on there now.
		if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("name")):
			textAni.play("CharAndBoxLeaving")
		# the only way this should ever be triggered is if both the current box
		# and next box don't have names.
		else:
			textAni.play("JustDelay")


# the point after the portraits are done moving, called on every new page
func _on_portraitslideoff_timeout():
	
	
	var oldName = currDialogue[1].name if currDialogue[1].has("name") else ""
	if (!narrationActive):
		holdDialogue = currDialogue[0].c_unescape()
		
	# we want the previous markers in case we are holding the bottom text and 
	# want to maintain the drawText colors and shaking
	var previousMarkers = currDialogue[1]["settings"]

	if (optionSelect):
		optionSelect = false
		currDialogue = pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkpath"]]["content"]
	else:
		currDialogue = pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"]

	if (currDialogue[0].length() < 1): currDialogue[0] = " "
	# start with the assumption that we're not needing to carry the previous markers
	currentMarkers = currDialogue[1]["settings"]
	
	
	var narratorAnimationHappening = false
	if (currDialogue[1].has("narrator")):
		#var textInstance = narratorData.instance()
		# Since we already loaded the text, just pass in the data and the next page
		if (!narrationActive):
			get_node("Narrator/CanvasLayer/Label").newText(pageText, currDialogue)
			narratorAnimationHappening = true
			narrationActive = true
			
			# for if we want to clear the box before naration comes in
			if (currDialogue[1]["narrator"].has("clearNormal")):
				visibleText = 0
				holdDialogue = ""
			else:
				currentMarkers = previousMarkers
		else:
			
			# This will have us update the text on the normal box, keeps
			# the narration box up, but clears its text
			if (currDialogue[1]["narrator"].has("clearNarration")):
				visibleText = 0
				holdDialogue = currDialogue[0].c_unescape()
				
			# Goes forward with narration, but clears the text on the normal box
			if (currDialogue[1]["narrator"].has("clearNormal")):
				visibleText = 0
				get_node("Narrator/CanvasLayer/Label").updateText(pageText, currDialogue)
				narrationActive = true
				# we're clearing the dialogue which means we want to clear the whole
				# so allCharacters will be 0
				holdDialogue = ""
			
			# We want to keep the text but draw the text in the new box
			if (currDialogue[1]["narrator"].has("continueNormal")):
				visibleText = 0
				holdDialogue = currDialogue[0].c_unescape()
			else:
				get_node("Narrator/CanvasLayer/Label").updateText(pageText, currDialogue)
				narrationActive = true
				currentMarkers = previousMarkers


			

	else:
		if (narrationActive):
			emit_signal("closeNarration")
			narratorAnimationHappening = true
		
		narrationActive = false
		visibleText = 0
		holdDialogue = currDialogue[0].c_unescape()

	currentMarker = 0
	allCharacters = holdDialogue.length()


	# decides if we should have text in the center or space it for two lines.
	if (currDialogue[1].has("centered")):
		self.rect_position = Vector2(15, 213)
	else:
		self.rect_position = Vector2(15, 205)
		
		
	checkDelay()
	get_node("../../CanvasLayer2/NameBox").updateName(currDialogue[1].name if currDialogue[1].has("name") else "", oldName)

	# we want to wait for the box to come up first
	if (!narratorAnimationHappening):
		get_node("textScroller").start()
	
# we start the timer here if we needed to wait for the box
func _on_Narration_opened():
	get_node("textScroller").start()

func _on_Narration_Exited():
	get_node("textScroller").start()

# the whole point of this is to create a short delay that let's the PromptSound play out to give space between boxes
# The primary point of this function is to create a small delay to let any boxes leave that need to leave
# it does not care about how long a normal movement is, it just happens when the text is drawn
func _on_PromptSound_finished():
	
	# first check to see if we need to move any portraits off screen
	get_node("../../CanvasLayer2/Portraits").checkLeavePortraits(currDialogue[1]["settings"][currentMarker].portraits)
	
	# see if there are any portraits wanting to exit using getLongestSlideOff
	# if there are, a non 0 value will be returned that indicates how long to wait
	# before moving to the next box
	var waitTime = get_node("../../CanvasLayer2/Portraits").getLongestSlideOff(currDialogue[1]["settings"][currentMarker].portraits)
	if (waitTime > 0):
		get_node("portraitslideoff").wait_time = waitTime
		get_node("portraitslideoff").start()
	else:
		# Just go right to the next one with no waiting since no characters are moving off screen
		_on_portraitslideoff_timeout()


# This logic is for after we've selected an option
func _on_Select_finished():
	# first check to see if we need to move any portraits off screen
	get_node("../../CanvasLayer2/Portraits").checkLeavePortraits(currDialogue[1]["settings"][currentMarker].portraits)
	optionSelect = true
	# see if there are any portraits wanting to exit using getLongestSlideOff
	# if there are, a non 0 value will be returned that indicates how long to wait
	# before moving to the next box
	var waitTime = get_node("../../CanvasLayer2/Portraits").getLongestSlideOff(currDialogue[1]["settings"][currentMarker].portraits)
	if (waitTime > 0):
		get_node("portraitslideoff").wait_time = waitTime
		get_node("portraitslideoff").start()
	else:
		# Just go right to the next one with no waiting since no characters are moving off screen
		_on_portraitslideoff_timeout()


