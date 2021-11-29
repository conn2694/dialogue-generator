extends Control


var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Makes sure that the values update, then save them into the data variable
func savePortraits():
	

	data = {}
	# If there's no character there's no real point in saving the information
	if (get_node("Lt 1").data.character != "N\/A"):
		data["Lt 1"] = get_node("Lt 1").data
	if (get_node("Lt 2").data.character != "N\/A"):
		data["Lt 2"] = get_node("Lt 2").data
	if (get_node("Rt 1").data.character != "N\/A"):
		data["Rt 1"] = get_node("Rt 1").data
	if (get_node("Rt 2").data.character != "N\/A"):
		data["Rt 2"] = get_node("Rt 2").data
		
	
#	data = {
#		"Lt 1": get_node("Lt 1").data,
#		"Lt 2": get_node("Lt 2").data,
#		"Rt 1": get_node("Rt 1").data,
#		"Rt 2": get_node("Rt 2").data
#	}.duplicate(true)

# used to get the data for every portrait, this function calls to update
# the data with up to date values, and then returns the data
func getPortraitData():
	savePortraits()
	return data.duplicate(true)
	
func getInitialPortraits():
	return {
		"Lt 1": get_node("Lt 1").getInitData(),
		"Lt 2": get_node("Lt 2").getInitData(),
		"Rt 1": get_node("Rt 1").getInitData(),
		"Rt 2": get_node("Rt 2").getInitData()
	}

# Simply update all the controls for every portrait, used for interactions in the
# main and page scripts, uses the data of each node to update their control
func updateAllPortraits(marker):
	get_node("Lt 1").updateControls(marker["Lt 1"] if marker.has("Lt 1") else {})
	get_node("Lt 2").updateControls(marker["Lt 2"] if marker.has("Lt 2") else {})
	get_node("Rt 1").updateControls(marker["Rt 1"] if marker.has("Rt 1") else {})
	get_node("Rt 2").updateControls(marker["Rt 2"] if marker.has("Rt 2") else {})

func releaseFocus():
	get_node("Lt 1").releaseFocus()
	get_node("Lt 2").releaseFocus()
	get_node("Rt 1").releaseFocus()
	get_node("Rt 2").releaseFocus()
	
func arePortraitButtonsPressed():
	if (get_node("Lt 1").isOptionButtonPressed()): return true
	elif(get_node("Lt 2").isOptionButtonPressed()): return true
	elif(get_node("Rt 2").isOptionButtonPressed()): return true
	elif(get_node("Rt 1").isOptionButtonPressed()): return true
	else: return false
	
