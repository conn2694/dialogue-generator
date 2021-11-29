extends Node




var buttonPressed = false # used to prevent overwrites when slider values change
var currObject = "okay"
var currObjName = currObject # used to keep track of what to name new nodes
var pageScene = preload("res://page.tscn") #preload to have it right away
var objScene = preload("res://object.tscn")

var currentPage = null
var initialPage = null
# Called when the node enters the scene tree for the first time.
func _ready():

	# initialize disabled
	#get_node("/root").name = "testing"
	get_node("CurrentPage").text = "pg 1"
	get_node("Previous").disabled = true
	get_node("Next").disabled = true
	get_node("../Options/Option1/NextOp1").disabled = true	
	get_node("../Options/Option2/NextOp2").disabled = true
	get_node("../Options/Option3/NextOp3").disabled = true
	get_node("Delete").disabled = true

	
	# *******************************************
	#	Create a new page! Eventually put this in a function
	# *******************************************
	var pageFolder = objScene.instance()
	pageFolder.name = currObject
	get_node("Pages").add_child(pageFolder)
	var pageInstance = pageScene.instance()
	pageInstance.name = currObject
	get_node("Pages/" + currObject).add_child(pageInstance)
	currentPage = pageInstance
	get_node("Pages/" + currObject).initial = currentPage.name



func _on_Next_pressed():
#	buttonPressed = true
#	savePage() # save page before switching
#	currPage += 1 # go forward a page
#	checkButtons()
#	updateControls()
#	unfocus()

	# For shortcuts, if we try to trigger this function while the button is disabled
	# don't continue with any operations
	if (get_node("Next").disabled == true):
		return
	
	# new linked list version
	buttonPressed = true
	currentPage.savePage()
	currentPage = get_node("Pages/" + currObject + "/" + currentPage.divert)
	checkButtons()
	updateControls()
	unfocus()
	currObjName = currentPage.name
	buttonPressed = false
	
	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)

func _on_Previous_pressed():
#	buttonPressed = true
#	savePage() # save page before switching
#	currPage -= 1 # go back a page
#	checkButtons() # now that we're in the new page make sure we can't press new buttons that would crash
#	updateControls() # and update the parameters on the controls with this page
#	unfocus() # and unfocus on the buttons so we don't trigger things with *space*
#



	if (get_node("Previous").disabled == true):
		return

	# new linked list version	
	buttonPressed = true
	currentPage.savePage()
	currentPage = get_node("Pages/" + currObject + "/" + currentPage.previous)
	checkButtons()
	updateControls()
	unfocus()
	currObjName = currentPage.name
	buttonPressed = false
	
	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)
	
func _on_Create_pressed():

	buttonPressed = true
	currentPage.savePage()
	resetControls()
	
	var pageInstance = pageScene.instance()
	pageInstance.name = currObject + " " + str(get_node("Pages/" + currObject).pageCount)
	get_node("Pages/" + currObject).add_child(pageInstance)
	# change the pointers on branches


	# if it's being inserted in between two boxes link all three
	if (currentPage.divert != ""):
		

			
		# link the new page to both boxes
		pageInstance.divert = get_node("Pages/" + currObject + "/" + currentPage.divert).name
		pageInstance.previous = currentPage.name

		# link both boxes to the new page
		# if this condition doesn't pass, it means that the next page we're putting this inbetween
		# is actually the page that this branch is breaking off into, so that page's previous shouldn't be updated
		if (get_node("Pages/" + currObject + "/" + pageInstance.divert).previous == pageInstance.previous):

			get_node("Pages/" + currObject + "/" + currentPage.divert).previous = pageInstance.name
		currentPage.divert = pageInstance.name

	# Adding a new box at the end
	else:
		currentPage.divert = pageInstance.name
		pageInstance.previous = currentPage.name
	

	# replace the previous last one with the new last one
	replaceNode(currentPage, get_node("Pages/" + currObject + "/" + currentPage.divert).divert, currentPage.divert, pageInstance)
	currentPage = pageInstance
	get_node("Pages/" + currObject).pageCount += 1
	checkButtons()
	updateControls()
	unfocus()
	buttonPressed = false
	

	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)
	
	# DO RECURSIVE REASIGNS HERE IF THE CURRENT PAGE HAS BRANCHES
	
# TODO: 
# * GET THIS WORKING WITH BRANCHES, IF WE DELETE A ROOT BRANCH, WE WANT TO CHECK IF THERE IS
#	ANOTHER ONE IN FRONT TO CONNECT IT TO, IF NOT JUST DELETE THE WHOLE BRANCH.
#	ALTERNATIVELY: WE CAN CREATE DELETE BUTTONS FOR EVERY BRANCH TO MAKE THIS PROCESS
#	MORE SIMPLE
#	Do this by checking during a deletion if the node name of the node being deleted
#	to the previous node was one of the option buttons
# * have this remove a page from the current position of the array, have it also
# * delete entire branches to if we choose to delete a page with options attached
# * when we click this have it give us a confirmation prompt so we don't delete something from
#	clicking it on accident
func _on_Delete_pressed():

	if (get_node("Delete").disabled == true):
		return

	# a node needs to be updated
	# deleting a node in between
	buttonPressed = true
	var deletingPage = currentPage
	var previousPage = get_node("Pages/" + currObject + "/" + currentPage.previous)
	var nextPage = get_node("Pages/" + currObject + "/" + currentPage.divert)
	
	# page is inbetween two other pages
	if (currentPage.divert != "" && currentPage.previous != ""):
		#find out if the previous pointer was a divert or option
		var option = 0

		# find if previous page was diverting to the current page, or was an option
		if (previousPage.divert == currentPage.name):
			option = 0
		elif (previousPage.option1 == currentPage.name):
			option = 1
		elif (previousPage.option2 == currentPage.name):
			option = 2
		elif (previousPage.option3 == currentPage.name):
			option = 3



		# we're deleting the first page of a branching box
		if (option > 0):
			# for seeing if the page we're deleting is the last one on a branch
			var previousDivert = previousPage.divert
			# it is the last as well
			if (currentPage.divert == previousDivert):
				match (option):
					1:
						previousPage.option1 = ""
					2:
						previousPage.option2 = ""
					3:
						previousPage.option3 = ""
			else:
				match (option):
					1:
						previousPage.option1 = get_node("Pages/" + currObject + "/" + currentPage.divert).name
					2:
						previousPage.option2 = get_node("Pages/" + currObject + "/" + currentPage.divert).name
					3:
						previousPage.option3 = get_node("Pages/" + currObject + "/" + currentPage.divert).name


		# normal divert, no options
		else:
			# link next page to the last page
			previousPage.divert = nextPage.name
			
		# We need to make sure that the nextPage isn't a lower branch
		# there's no need to update it unless it actually knows about 
		# the previous page (in that case, it's on the same branch and should
		# be updated)
		if (nextPage.previous == currentPage.name):
			nextPage.previous = currentPage.previous

		replaceNode(previousPage, currentPage.name, currentPage.divert, get_node("Pages/" + currObject + "/" + currentPage.divert))
		
		# after going through the options, make sure that if the reference is directly being pointed
		# to that it's removed
				
		
		currentPage = get_node("Pages/" + currObject + "/" + currentPage.divert); # go forwards
		
		get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)
	
		deleteNode(deletingPage, get_node("Pages/" + currObject + "/" + deletingPage.divert))
	
	# deleting a node at the end
	elif (currentPage.previous != ""):
		# if there are references to he node being deleted from options previously,
		# we want those updated to ""
		
		# after going through the options, make sure that if the reference is directly being pointed
		# to that it's removed
		if (previousPage.option1 == currentPage.name):
			previousPage.option1 = ""
		elif (previousPage.option2 == currentPage.name):
			previousPage.option2 = ""
		elif (previousPage.option3 == currentPage.name):
			previousPage.option3 = ""
		
		replaceNode(previousPage, currentPage.name, currentPage.divert, get_node("Pages/" + currObject + "/" + currentPage.divert))
		
		get_node("Pages/" + currObject + "/" + currentPage.previous).divert = ""
		currentPage = get_node("Pages/" + currObject + "/" + currentPage.previous); # go back
		
		get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)
	
		deleteNode(deletingPage, get_node("Pages/" + currObject + "/" + deletingPage.divert))
	
	
	# deleting node at the beginning
	elif (currentPage.divert != ""):

		get_node("Pages/" + currObject + "/" + currentPage.divert).previous = ""
		currentPage = get_node("Pages/" + currObject + "/" + currentPage.divert); # go forwards

		get_node("Pages/" + currObject).initial = currentPage.name
		
		get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)
		
		deleteNode(deletingPage, get_node("Pages/" + currObject + "/" + deletingPage.divert))
	# the only box in the object, nothing left or right

	else:
		get_node("..").clearMarkers()
		# maybe allow the delete button to stay but just reset the settings and clear the text

	# THIS IS WHERE WE WOULD ACTUALLY DELETE THE NODE, EITHER A SIMPLE ONE, OR A RECURSIVE ONE WITH OPTIONS
	
	checkButtons()
	updateControls()
	unfocus()
	buttonPressed = false


	
func checkButtons():

	get_node("Next").disabled = false
	get_node("Previous").disabled = false
	get_node("../Options/Option1/NextOp1").disabled = false	
	get_node("../Options/Option2/NextOp2").disabled = false
	get_node("../Options/Option3/NextOp3").disabled = false
	get_node("Delete").disabled = true
	if (currentPage.divert == ""):
		get_node("Next").disabled = true
	if (currentPage.previous == ""):
		get_node("Previous").disabled = true
	if (currentPage.option1 == ""):
		get_node("../Options/Option1/NextOp1").disabled = true
	if (currentPage.option2 == ""):
		get_node("../Options/Option2/NextOp2").disabled = true
	if (currentPage.option3 == ""):
		get_node("../Options/Option3/NextOp3").disabled = true	
	if (currentPage.divert == "" && currentPage.previous == ""):
		get_node("Delete").disabled = true
		
# For when we want to hold ctrl to enable the delete button
func deleteBtnCheck(ctrlHeld):
	if (!currentPage.divert == "" || !currentPage.previous == ""):
		if (ctrlHeld):
			get_node("Delete").disabled = false
		else:
			get_node("Delete").disabled = true
	else:
		get_node("Delete").disabled = true
		

# When we enter a previous or next box, we want to put all the parameters back where we left them
func updateControls():

	get_node("..").currDia = currentPage.info["content"][0].c_unescape()
	get_node("..").currLetter = get_node("..").currDia.length() # put us at the end
	get_node("..").totalLetters = get_node("..").currDia.length() # important to prevent overflow
	get_node("..").markerList = currentPage.info["content"][1]["settings"]
	get_node("..").currMarker = get_node("..").markerList.size()-1 # last marker
	get_node("../Name box/TextEdit").text = currentPage.info["content"][1]["name"] if currentPage.info["content"][1].has("name") else "" # reload name
	get_node("../Box Controls").updateControls(
		currentPage.info["content"][1]["centered"] if currentPage.info["content"][1].has("centered") else false, 
		currentPage.info["content"][1]["narrator"] if currentPage.info["content"][1].has("narrator") else false, 
		currentPage.info["content"][1]["interrupt"] if currentPage.info["content"][1].has("interrupt") else false
	)
	get_node("../Note").updateControls(
		currentPage.info["content"][1]["note"] if currentPage.info["content"][1].has("note") else ""
	)
	get_node("../Note").checkIndicator()
	get_node("../Options/Option1").text = currentPage.info["content"][1]["options"][0]
	get_node("../Options/Option2").text = currentPage.info["content"][1]["options"][1]
	get_node("../Options/Option3").text = currentPage.info["content"][1]["options"][2]
	# delete all previous marker sprites

	for i in range(get_node("../TextDrawer/Markers").get_child_count()):

		get_node("../TextDrawer/Markers").get_child(i).queue_free()
		
	# load in the new ones
	for _i in range(get_node("..").markerList.size()-1): # -1 since we don't need a marker for the initial

		var markerSprite = Sprite.new()
		markerSprite.texture = load("marker.png")
		markerSprite.centered = false
		markerSprite.offset.y = -10
		markerSprite.position = Vector2(500, 500)
		get_node("../TextDrawer/Markers").add_child(markerSprite)
	get_node("Timer").start() # gives the sprites time to load
	get_node("..").updateControls() # now that we have markers back, update the parameters
	
# start fresh
func resetControls():

	get_node("..").currDia = ""
	get_node("..").currLetter = 0
	get_node("..").totalLetters = 0
	get_node("..").currMarker = 0
	get_node("..").markerList.clear()
	get_node("..").markerList.append(defaultMarker())
	get_node("../Name box/TextEdit").text = ""
	get_node("../Note").updateControls("")
	get_node("../Note").checkIndicator()
	get_node("../Box Controls").updateControls(false, false, false)
	get_node("..").updateControls()

	for i in range(get_node("../TextDrawer/Markers").get_child_count()):
		get_node("../TextDrawer/Markers").get_child(i).queue_free()

	
# After pressing a button we don't want to keep focused on it
func unfocus():
	get_node("Create").release_focus()
	get_node("Delete").release_focus()
	get_node("Next").release_focus()
	get_node("Previous").release_focus()
	get_node("../Options/Option1").release_focus()
	get_node("../Options/Option2").release_focus()
	get_node("../Options/Option3").release_focus()
	get_node("../Options/Option1/CreateOp1").release_focus()
	get_node("../Options/Option1/NextOp1").release_focus()
	get_node("../Options/Option2").release_focus()
	get_node("../Options/Option2/CreateOp2").release_focus()
	get_node("../Options/Option2/NextOp2").release_focus()
	get_node("../Options/Option3").release_focus()
	get_node("../Options/Option3/CreateOp3").release_focus()
	get_node("../Options/Option3/NextOp3").release_focus()
	get_node("../TextDrawer").update_text()
	get_node("../Object/New").release_focus()
	get_node("../Object/Delete").release_focus()
	get_node("../Object/CreateObject").release_focus()
	
# when we make a new box we want to have some defaults so you don't need to adjust all the time
# stuff involving speed and chars and sound still carry over since that seems more common
func defaultMarker():
	
	var marker = {
		"mark": 0,
		#"pi": 1,
		#"wave": 0,
		#"amp": 0,
		#"color": Color("ffffff").to_html(),
		"speed": get_node("../Speed/Speed/HSlider").value,
		"chars": get_node("../Speed/Chars/HSlider").value,
		"sound": get_node("../Speed/Sounds/Add").get_item_text(get_node("../Speed/Sounds/Add").get_selected_id()),
		#"pause": 0,
		"portraits": get_node("../Portraits").getPortraitData(),
		"sfx": get_node("../Sfx").soundFx,
		"pic": get_node("../Picture").image,
		"music": get_node("../Music").song,
		"shock": get_node("../Box Controls").shocked,
		"dim": get_node("../Box Controls").dimmed
	}
	
	newMarkerValueCheck(marker, "speed", get_node("../Speed/Speed/HSlider").value, 0.01)
	newMarkerValueCheck(marker, "chars", get_node("../Speed/Chars/HSlider").value, 1)
	newMarkerValueCheck(marker, "shock", get_node("../Box Controls").shocked, false)
	newMarkerValueCheck(marker, "dim", get_node("../Box Controls").dimmed, false)
	newMarkerValueCheck(marker, "prompt", get_node("../Box Controls").prompted, false)
	newMarkerValueCheck(marker, "sfx", get_node("../Sfx").soundFx, "None")
	newMarkerValueCheck(marker, "pic", get_node("../Picture").image, "None")
	newMarkerValueCheck(marker, "music", get_node("../Music").song, "N/A")
	
	return marker
	

func newMarkerValueCheck(dict, key, value, default):
	if (value != default):
		dict[key] = value
	else:
		dict.erase(key)


# this is an estimate on when the sprites will be reloaded for the markers
# we wait until this to create and reposition them
func _on_Timer_timeout():
	# put the new markers where they belong, created in updateControls
	for i in range(get_node("..").markerList.size()-1):
		get_node("../TextDrawer/Markers").get_child(i).position = get_node("../TextDrawer").charLen[get_node("..").markerList[i+1]["mark"]]


func _on_CreateOp1_pressed():
	buttonPressed = true
	currentPage.savePage()
	resetControls()
	
	var pageInstance = pageScene.instance()
	# takes the previous name and appends to it
	#currObjName += " " + str(pageCount) + " op1"
	pageInstance.name = currObject +  " op1 " + str(get_node("Pages/" + currObject).pageCount)
	
	
	get_node("Pages/" + currObject + "/").add_child(pageInstance)
	# if it's being inserted in between two boxes link all three
	if (currentPage.option1 != ""):
		# link the new page to both boxes
		pageInstance.divert = get_node("Pages/" + currObject + "/" + currentPage.option1).name
		pageInstance.previous = currentPage.name
		# link both boxes to the new page
		get_node("Pages/" + currObject + "/" + currentPage.option1).previous = pageInstance.name
		currentPage.option1 = pageInstance.name

	# Adding a new box at the end
	else:
		currentPage.option1 = pageInstance.name
		pageInstance.previous = currentPage.name
		# Important, links the option to the currentPage's divert
		pageInstance.divert = currentPage.divert

	get_node("Pages/" + currObject).pageCount += 1
	checkButtons()
	updateControls()
	unfocus()
	buttonPressed = false
	



func _on_NextOp1_pressed():
	
	if (get_node("../Options/Option1/NextOp1").disabled == true):
		return
	buttonPressed = true
	currentPage.savePage()
	currentPage = get_node("Pages/" + currObject + "/" + currentPage.option1)
	checkButtons()
	updateControls()
	unfocus()
	currObjName = currentPage.name
	buttonPressed = false
	
	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)


func _on_CreateOp2_pressed():
	buttonPressed = true
	currentPage.savePage()
	resetControls()
	
	var pageInstance = pageScene.instance()
	# takes the previous name and appends to it
	pageInstance.name = currObject +  " op2 " + str(get_node("Pages/" + currObject).pageCount)
	
	
	get_node("Pages/" + currObject + "/").add_child(pageInstance)
	# if it's being inserted in between two boxes link all three
	if (currentPage.option2 != ""):
		# link the new page to both boxes
		pageInstance.divert = get_node("Pages/" + currObject + "/" + currentPage.option2).name
		pageInstance.previous = currentPage.name
		# link both boxes to the new page
		get_node("Pages/" + currObject + "/" + currentPage.option2).previous = pageInstance.name
		currentPage.option2 = pageInstance.name

	# Adding a new box at the end
	else:
		currentPage.option2 = pageInstance.name
		pageInstance.previous = currentPage.name
		# Important, links the option to the currentPage's divert
		pageInstance.divert = currentPage.divert
		
	#currentPage = pageInstance
	get_node("Pages/" + currObject).pageCount += 1
	checkButtons()
	updateControls()
	unfocus()
	buttonPressed = false
	


func _on_NextOp2_pressed():
	if (get_node("../Options/Option2/NextOp2").disabled == true):
		return
	buttonPressed = true
	currentPage.savePage()
	currentPage = get_node("Pages/" + currObject + "/" + currentPage.option2)
	checkButtons()
	updateControls()
	unfocus()
	currObjName = currentPage.name
	buttonPressed = false
	
	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)



func _on_CreateOp3_pressed():
	buttonPressed = true
	currentPage.savePage()
	resetControls()
	
	var pageInstance = pageScene.instance()
	# takes the previous name and appends to it
	pageInstance.name = currObject +  " op3 " + str(get_node("Pages/" + currObject).pageCount)
	
	
	get_node("Pages/" + currObject + "/").add_child(pageInstance)
	# if it's being inserted in between two boxes link all three
	if (currentPage.option3 != ""):
		# link the new page to both boxes
		pageInstance.divert = get_node("Pages/" + currObject + "/" + currentPage.option3).name
		pageInstance.previous = currentPage.name
		# link both boxes to the new page
		get_node("Pages/" + currObject + "/" + currentPage.option3).previous = pageInstance.name
		currentPage.option3 = pageInstance.name

	# Adding a new box at the end
	else:
		currentPage.option3 = pageInstance.name
		pageInstance.previous = currentPage.name
		# Important, links the option to the currentPage's divert
		pageInstance.divert = currentPage.divert
		
	#currentPage = pageInstance
	get_node("Pages/" + currObject).pageCount += 1
	checkButtons()
	updateControls()
	unfocus()
	buttonPressed = false


func _on_NextOp3_pressed():
	if (get_node("../Options/Option3/NextOp3").disabled == true):
		return
	buttonPressed = true
	currentPage.savePage()
	currentPage = get_node("Pages/" + currObject + "/" + currentPage.option3)
	checkButtons()
	updateControls()
	unfocus()
	currObjName = currentPage.name
	buttonPressed = false
	
	get_node("CurrentPage").text = "pg " + findNode(get_node("Pages/" + currObject + "/" + get_node("Pages/" + currObject).initial), currentPage)


func getAllPrevious():
	var nodeCheck = currentPage
	var amount = 0
	while (nodeCheck.previous != ""):
		nodeCheck = nodeCheck.previous
		amount += 1
	return amount

# recursive function to get a formatting for what text box we're on
# startNode starts as the initial page of the object
# targetNode is the node we are moving to, and want to represent through text
func findNode(startNode, targetNode):

	var nodeCheck = startNode#get_node("Pages/" + currObject)
	var page = 1 # page number of the current layer of the tree
	var trackStr = "" # saves the previous strings
	var previousDivert = ""
	
	# we're on a branch, get the point where the branch ends
	if (startNode.previous != ""):
		previousDivert = get_node("Pages/" + currObject + "/" + startNode.previous).divert
	
	# simulate do while by doing an initial actions first
	
	if (nodeCheck.name == targetNode.name): # we found the actual node
		return str(page) # begin the recursive return

	# branches, check all of them for a matching one
	if (nodeCheck.option1 != ''): # if there's a branch at all
		# go into the branch and search for our target
		trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), targetNode)
		# if we had a match (not null) recursively return the strings to format
		if (trackStr != null):
			return str(page) + " C1 " + trackStr
	if (nodeCheck.option2 != ''):
		trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option2), targetNode)
		if (trackStr != null):
			return str(page) + " C2 " + trackStr
	if (nodeCheck.option3 != ''):
		trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option3), targetNode)
		if (trackStr != null):
			return str(page) + " C3 " + trackStr
	
	
	# while we're not at the last one
	while (nodeCheck.divert != previousDivert):
		# go to next node
		nodeCheck = get_node("Pages/" + currObject + "/" + nodeCheck.divert)
		page += 1;
		if (nodeCheck.name == targetNode.name):
			return str(page)

		# branches, check all of them for a matching one
		if (nodeCheck.option1 != ''):
			trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), targetNode)
			if (trackStr != null):
				return str(page) + " C1 " + trackStr
		if (nodeCheck.option2 != ''):
			trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option2), targetNode)
			if (trackStr != null):
				return str(page) + " C2 " + trackStr
		if (nodeCheck.option3 != ''):
			trackStr = findNode(get_node("Pages/" + currObject + "/" + nodeCheck.option3), targetNode)
			if (trackStr != null):
				return str(page) + " C3 " + trackStr



# recursive function to update pointers to a new page
# startNode is the node we start with
# oldNode is the old reference we want to replace with newNode
# cutoffNode is the node we use to determine when the end of a branch is
func replaceNode(startNode, oldNode, newNode, cutoffNode):
	var nodeCheck = startNode
	
	# simulate do while by doing an initial actions first
	
	# first node we start at is also the last one
	if (nodeCheck.divert == oldNode):
		nodeCheck.divert = newNode

	# branch from options
	if (nodeCheck.option1 != ''): # if there's a branch at all
		# go into the branch and search for our target
		replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))

	if (nodeCheck.option2 != ''):
		replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option2), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))

	if (nodeCheck.option3 != ''):
		replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option3), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))
	

	
	# we have already done the operations we need since this is the last
	# node before the target, just exit out
	if (nodeCheck.divert == cutoffNode.name || nodeCheck.divert == ""):
		return
	
	# while we're not at the last page of the branch
	while (nodeCheck.divert != cutoffNode.name && nodeCheck.divert != ""):
		# go to next node
		nodeCheck = get_node("Pages/" + currObject + "/" + nodeCheck.divert)

		# big part of this function, when we find the node connecting to the old
		# name, connect to the new one instead
		if (nodeCheck.divert == oldNode):
			nodeCheck.divert = newNode

		# branches, check all of them for a matching one
		if (nodeCheck.option1 != ''):
			replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))

		if (nodeCheck.option2 != ''):
			replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option2), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))

		if (nodeCheck.option3 != ''):
			replaceNode(get_node("Pages/" + currObject + "/" + nodeCheck.option3), oldNode, newNode, get_node("Pages/" + currObject + "/" + nodeCheck.divert))

# recursive function to update pointers to a new page
# startnode is the node that the function starts at
# cutoff node describes when to stop the deletion
func deleteNode(startNode, cutoffNode):
	var nodeCheck = startNode
	
	# simulate do while by doing an initial actions first
	
	# first node we start at is also the last one

	# branch from options
	if (nodeCheck.option1 != ''): # if there's a branch at all
		# go into the branch and search for our target
		deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), get_node("Pages/" + currObject + "/" + nodeCheck.divert))

	if (nodeCheck.option2 != ''):
		deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option2), get_node("Pages/" + currObject + "/" + nodeCheck.divert))

	if (nodeCheck.option3 != ''):
		deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option3), get_node("Pages/" + currObject + "/" + nodeCheck.divert))
	

	
	# we have already done the operations we need since this is the last
	# node before the target, just exit out
	if (nodeCheck.divert == cutoffNode.name || nodeCheck.divert == ""):
		nodeCheck.queue_free()
		return
	
	# while we're not at the last page of the branch
	while (nodeCheck.divert != cutoffNode.name && nodeCheck.divert != ""):
		# go to next node
		nodeCheck.queue_free()
		nodeCheck = get_node("Pages/" + currObject + "/" + nodeCheck.divert)

		# big part of this function, when we find the node connecting to the old
		# name, connect to the new one instead

		# branches, check all of them for a matching one
		if (nodeCheck.option1 != ''):
			deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), get_node("Pages/" + currObject + "/" + nodeCheck.divert))

		if (nodeCheck.option2 != ''):
			deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), get_node("Pages/" + currObject + "/" + nodeCheck.divert))

		if (nodeCheck.option3 != ''):
			deleteNode(get_node("Pages/" + currObject + "/" + nodeCheck.option1), get_node("Pages/" + currObject + "/" + nodeCheck.divert))
	nodeCheck.queue_free()


