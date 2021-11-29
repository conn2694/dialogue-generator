extends ConfirmationDialog



var currObj = null
var currObjName = ""
var saveText = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# initial values when the window is opened up
func _on_New_pressed():
	self.popup_centered()
	currObj = get_node("../CurrentObject").get_selected_id()
	currObjName = get_node("../CurrentObject").get_item_text(currObj)
	
	# Default values
	get_node("Container/Flag").pressed = false
	get_node("Container/Iterating").pressed = false
	get_node("Container/Copy").pressed = false
	get_node("Container/LineEdit").text = ""
	self.get_ok().disabled = true 
	
	
	# disable until we get a unique name for the object
	get_node("Container/LineEdit").grab_focus()
	#TODO: Check the names of all the objects to make sure the object we're on now
	# doesn't already have a flag or iterate made, if they do disable that option
	# and put some text that says "already made that iteration"


func _on_Iterating_toggled(button_pressed):
	if (button_pressed):
		get_node("Container/LineEdit").visible = false
		get_node("Container/Flag").disabled = true
		saveText = get_node("Container/LineEdit").text
		get_node("Container/LineEdit").text = buildIterString()

	else:
		get_node("Container/LineEdit").text = saveText
		get_node("Container/LineEdit").visible = true
		get_node("Container/Flag").disabled = false


	self.get_ok().disabled = okTest()

func _on_Flag_toggled(button_pressed):
	if (button_pressed):
		get_node("Container/LineEdit").visible = false
		get_node("Container/Iterating").disabled = true
		saveText = get_node("Container/LineEdit").text
		get_node("Container/LineEdit").text = currObjName + "Flag"
			
	else:
		
		get_node("Container/LineEdit").text = saveText
		get_node("Container/LineEdit").visible = true
		get_node("Container/Iterating").disabled = false

	self.get_ok().disabled = okTest()

# Doing this to check for duplicates of other names
func _on_LineEdit_text_changed(new_text):
	
	self.get_ok().disabled = okTest()

func okTest():
	
	#One of the automatic buttons are pressed like Flag or Iterate are pressed
	if (get_node("Container/Flag").pressed):
		# we already have an iteration of this object
		if (isDuplicate(get_node("Container/LineEdit").text)):
			return true
		else:
			return false
	elif (get_node("Container/Iterating").pressed):
		# we already have a flag for this object
		if (isDuplicate(get_node("Container/LineEdit").text)):
			return true
		else:
			return false
	else:
		#Text is in the textEdit name
		if (get_node("Container/LineEdit").text.length() > 0):
			# Name is duplicated from another object
			if (isDuplicate(get_node("Container/LineEdit").text)):
				return true
			else:
				return false
		else:
			return true
			

func isDuplicate(text):
	var objects = get_node("../CurrentObject")

	for i in range(objects.get_item_count()):
		if (objects.get_item_text(i) == text):
			return true
	return false
		
	
func buildIterString():
	var append = ""
	var i = 0
	# Parse out the previous iteration
	while (currObjName[currObjName.length()-i-1].is_valid_integer()):
		append = currObjName.right(currObjName.length()-i-1)
		i += 1
	
	# strip previous number
	currObjName = currObjName.left(currObjName.length()-i)
	
	# append on the new iterated value
	var iter = append.to_int() + 1
	
	if (append == ""):
		return (currObjName + "1")
	else:
		return (currObjName + str(iter))

