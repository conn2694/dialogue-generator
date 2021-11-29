extends Control

enum  {
	STAY,
	LEFT,
	RIGHT
}
var currLeaveState = STAY
var currEnterState = STAY
var currLayer = 0
const stayBtn = preload("res://theme/stay_button.png")
const leftBtn = preload("res://theme/exit_left_button.png")
const rightBtn = preload("res://theme/exit_right_button.png")
const stayHint = "Not exiting:\nPortrait is not exiting at the \nbeginning of the next box"
const leftHint = "Exit Left:\nPortrait leaves to the left side next box"
const rightHint = "Exit Right:\nPortrait leaves to the right side next box"


const enterLeftBtn = preload("res://theme/enter_left_button.png")
const enterRightBtn = preload("res://theme/enter_right_button.png")
const enterStayHint = "Not entering:\nPortrait is not entering at \nthe beginning of this box"
const enterLeftHint = "Enter Left:\nPortrait enters from the left side"
const enterRightHint = "EnterRight:\nPortrait enters from the right side"

const btn1 = preload("res://theme/1_ button.png")
const btn2 = preload("res://theme/2_button.png")
const btn3 = preload("res://theme/3_button.png")
const btn4 = preload("res://theme/4_button.png")

# list them out so we can move back and forth easily
var btnList = [btn1, btn2, btn3, btn4]

var data = {
	"character": "N\/A",
	"face": "N\/A",
	"flipped": false,
	"shocked": false,
	"dimmed": false,
	"leaveType": "stay",
	"enterType": "stay",
	"position": 0,
	"speed": 0.3,
	"layer": 0
}


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Exit").hint_tooltip = stayHint



func _on_Exit_pressed():
	match currLeaveState:
		STAY:
			currLeaveState = LEFT
			markerValueCheck("leaveType", "left", "stay")
			get_node("Exit").texture_normal = leftBtn
			get_node("Exit").hint_tooltip = leftHint
		LEFT:
			currLeaveState = RIGHT
			markerValueCheck("leaveType", "right", "stay")
			get_node("Exit").texture_normal = rightBtn
			get_node("Exit").hint_tooltip = rightHint
		RIGHT:
			currLeaveState = STAY
			markerValueCheck("leaveType", "stay", "stay")
			get_node("Exit").texture_normal = stayBtn
			get_node("Exit").hint_tooltip = stayHint
	get_node("../..").updateMarker()



func _on_Mirror_toggled(button_pressed):
	markerValueCheck("flipped", button_pressed, false)
	get_node("../..").updateMarker()
func _on_Shock_toggled(button_pressed):
	markerValueCheck("shocked", button_pressed, false)
	get_node("../..").updateMarker()
func _on_Dim_toggled(button_pressed):
	markerValueCheck("dimmed", button_pressed, false)
	get_node("../..").updateMarker()

func _on_Face_item_selected(index):
	data.face = get_node("Face").get_item_text(index)
	get_node("../..").updateMarker()
	get_node("../Preview").hide()
	print("face selected")
	

func updateControls(marker):

	# we want to update back to default values if we detect them
	if (marker.empty()):
		for i in range(get_node("Character").get_item_count()):
			if ("N/A" == get_node("Character").get_item_text(i)):

				get_node("Character").select(i)
				get_node("Face")._on_Character_item_selected(i)
				data.character = "N/A"
		for i in range(get_node("Face").get_item_count()):
			if ("N/A" == get_node("Face").get_item_text(i)):
				get_node("Face").select(i)
				data.face = "N/A"
				
		# Update toggled buttons
		get_node("Shock").pressed = false
		get_node("Dim").pressed = false
		get_node("Mirror").pressed = false
		markerValueCheck("flipped", false, false)
		markerValueCheck("shocked", false, false)
		markerValueCheck("dimmed", false, false)
		
		get_node("Position").value = 0
		data.position = 0
		
		get_node("Speed").value = 0.3
		floatValueCheck("speed", 0.3, 0.3)
		
		# 3 is the max layer, so we want to roll over back to 0 in the function
		currLayer = 0
		updateLayerBtn(currLayer)
		
		currLeaveState = RIGHT
		_on_Exit_pressed()
		currEnterState = RIGHT
		_on_Enter_pressed()
		return
		

	
	# Find the corresponding value in the node
	for i in range(get_node("Character").get_item_count()):
		if (marker["character"] == get_node("Character").get_item_text(i)):

			get_node("Character").select(i)
			get_node("Face")._on_Character_item_selected(i)
			data.character = marker["character"]

	for i in range(get_node("Face").get_item_count()):
		if (marker["face"] == get_node("Face").get_item_text(i)):
			get_node("Face").select(i)
			data.face = marker["face"]

	# Update toggled buttons
	get_node("Shock").pressed = marker["shocked"] if marker.has("shocked") else false
	get_node("Dim").pressed = marker["dimmed"]  if marker.has("dimmed") else false
	get_node("Mirror").pressed = marker["flipped"]  if marker.has("flipped") else false
	markerValueCheck("shocked", marker["shocked"] if marker.has("shocked") else false, false)
	markerValueCheck("dimmed", marker["dimmed"] if marker.has("dimmed") else false, false)
	markerValueCheck("flipped", marker["flipped"] if marker.has("flipped") else false, false)

	get_node("Position").value = marker["position"]
	data.position = marker["position"]
	
	get_node("Speed").value = marker["speed"] if marker.has("speed") else 0.3
	floatValueCheck("speed", marker["speed"] if marker.has("speed") else 0.3, 0.3)
	
	
	currLayer = marker["layer"] if marker.has("layer") else 0
	updateLayerBtn(currLayer)
			
	
	# assign the exit state, get the previous one so we can assign everything in
	# _on_Exit_pressed()
	if (marker.has("leaveType")):
		if (marker["leaveType"] == "stay"): currLeaveState = RIGHT
		elif (marker["leaveType"] == "left"): currLeaveState = STAY
		elif (marker["leaveType"] == "right"): currLeaveState = LEFT
	else:
		currLeaveState = RIGHT
	_on_Exit_pressed()
	
	if (marker.has("enterType")):	
		if (marker["enterType"] == "stay"): currEnterState = RIGHT
		elif (marker["enterType"] == "left"): currEnterState = STAY
		elif (marker["enterType"] == "right"): currEnterState = LEFT
	else:
		currEnterState = RIGHT
	_on_Enter_pressed()
	
	
func releaseFocus():
	get_node("Character").release_focus()
	get_node("Face").release_focus()
	get_node("Mirror").release_focus()
	get_node("Dim").release_focus()
	get_node("Shock").release_focus()
	get_node("Exit").release_focus()
	get_node("Enter").release_focus()
	get_node("Position").release_focus()
	get_node("Speed").release_focus()
	get_node("Layer").release_focus()

func getInitData():
	return {
		"character": "N/A",
		"face": "N/A",
		"flipped": false,
		"shocked": false,
		"dimmed": false,
		"leaveType": "stay",
		"enterType": "stay",
		"position": 0,
		"speed": 0.3,
		"layer": 0
	}


func markerValueCheck(key, value, default):
	

	
	if (value != default):
		data[key] = value
	else:
		data.erase(key)

func floatValueCheck(key, value, default):
	if (abs(value - default) <= 0.001):	
		data.erase(key)
	else:
		data[key] = value


func _on_Position_value_changed(value):
	data.position = value
	get_node("../..").updateMarker()


func _on_Enter_pressed():
	match currEnterState:
		STAY:
			currEnterState = LEFT
			markerValueCheck("enterType", "left", "stay")

			get_node("Enter").texture_normal = enterLeftBtn
			get_node("Enter").hint_tooltip = enterLeftHint
		LEFT:
			currEnterState = RIGHT
			markerValueCheck("enterType", "right", "stay")

			get_node("Enter").texture_normal = enterRightBtn
			get_node("Enter").hint_tooltip = enterRightHint
		RIGHT:
			currEnterState = STAY
			markerValueCheck("enterType", "stay", "stay")

			get_node("Enter").texture_normal = stayBtn
			get_node("Enter").hint_tooltip = enterStayHint
	get_node("../..").updateMarker()


func _on_Layer_pressed():
	if (Input.is_action_just_released("right_click")):
		currLayer -= 1
		if (currLayer < 0):
			currLayer = 3
	elif (Input.is_action_just_released("left_click")):
		currLayer += 1
		if (currLayer > 3):
			currLayer = 0

	updateLayerBtn(currLayer)
		
func updateLayerBtn(value):
	get_node("Layer").texture_normal = btnList[value]
	markerValueCheck("layer", value, 0)
	get_node("../..").updateMarker()
	

func _on_Speed_value_changed(value):
	floatValueCheck("speed", value, 0.3)
	get_node("../..").updateMarker()

func isOptionButtonPressed():
	return (get_node("Character").pressed || get_node("Face").pressed)


# used to update the sprite
func _on_Face_item_focused(index):
	get_node("../Preview").show()
	get_node("../Preview").updateSprite("portraits/" + data.character + "/" + get_node("Face").get_item_text(index))

func _on_Face_pressed():
	if (self.name == "Lt 1" || self.name == "Lt 2"):
		get_node("../Preview").position.x = 236
		get_node("../Preview").flip_h = false
	else:
		get_node("../Preview").position.x = 100
		get_node("../Preview").flip_h = true
		
	print("portraits/" + data.character + "/" + data.face)
		
	get_node("../Preview").updateSprite("portraits/" + data.character + "/" + data.face)
	get_node("../Preview").show()
