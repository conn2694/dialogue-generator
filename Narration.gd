extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var narrData

# Called when the node enters the scene tree for the first time.
func _ready():
	narrData = get_node("..").narrator


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Continue_Normal_toggled(button_pressed):
	if (button_pressed):
		narrData["continueNormal"] = true
	else:
		narrData.erase("continueNormal")
		


func _on_Clear_Normal_toggled(button_pressed):
	if (button_pressed):
		narrData["clearNormal"] = true
	else:
		narrData.erase("clearNormal")


func _on_Clear_Narration_toggled(button_pressed):
	if (button_pressed):
		narrData["clearNarration"] = true
	else:
		narrData.erase("clearNarration")
		
func clearAll():
		narrData.erase("clearNarration")
		narrData.erase("clearNormal")
		narrData.erase("continueNormal")
		
func updateControls(narr):
	narrData = get_node("..").narrator
	if (!get_node("..").narration):
		get_node("Clear Narration").visible = false
		get_node("Clear Normal").visible = false
		get_node("Continue Normal").visible = false
	else:
		get_node("Clear Narration").visible = true
		get_node("Clear Normal").visible = true
		get_node("Continue Normal").visible = true
	get_node("Clear Narration").pressed = narr.has("clearNarration")
	get_node("Clear Normal").pressed = narr.has("clearNormal")
	get_node("Continue Normal").pressed = narr.has("continueNormal")

func updateValueswithControls():
	if (get_node("Clear Narration").pressed):
		narrData["clearNarration"] = true
	else:
		narrData.erase("clearNarration")
		
	if (get_node("Clear Normal").pressed):
		narrData["clearNormal"] = true
	else:
		narrData.erase("clearNormal")
		
	if (get_node("Continue Normal").pressed):
		narrData["continueNormal"] = true
	else:
		narrData.erase("continueNormal")
