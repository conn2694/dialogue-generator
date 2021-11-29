extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var divert = ""
export var previous = ""
export var option1 = ""
export var option2 = ""
export var option3 = ""
var info
const ROOT = "../../../.."
var optText = []
var ready = false



# Constructor, initializes the page
func _init(): 
	info = {
		"content": [
		"", # empty text
		{
			#"name": "", # resetControls initializes this to empty string
			#"note": "",
			#"narrator": false,
			#"centered": false,
			#"cutoff": "normal",
			"divert": divert,
			"previous": previous,
			"options": ["", "", ""],
			"settings": [], 
			
		}
	]}
	
# after it's fully loaded
func _ready(): 
	info = {
		"content": [
		"", # empty text
		{
			"name": get_node(ROOT + "/Name box/TextEdit").text, # resetControls initializes this to empty string
			"note": get_node(ROOT + "/Note").notes,
			"narrator": get_node(ROOT + "/Box Controls").narrator,
			"centered": get_node(ROOT + "/Box Controls").centered, 
			"interrupt": get_node(ROOT + "/Box Controls").interrupt,
			"divert": divert,
			"previous": previous,
			"options": ["", "", ""],
			"settings": get_node(ROOT).markerList.duplicate(true), #duplicate so we copy the contents, not the address

		}
	]}
	varValueCheck("name", get_node(ROOT + "/Name box/TextEdit").text, "")
	varValueCheck("note", get_node(ROOT + "/Note").notes, "")
	varValueCheck("narrator", get_node(ROOT + "/Box Controls").narration, false)
	varValueCheck("centered", get_node(ROOT + "/Box Controls").centered, false)	
	varValueCheck("interrupt", get_node(ROOT + "/Box Controls").interrupt, false)
	
	ready = true
	

func savePage():

	var options = getOptionCount()

	if (options == 0):
		info = {
			"content": [
			get_node(ROOT).currDia.c_escape(), # text
			{
				"name": get_node(ROOT + "/Name box/TextEdit").text,
				"note": get_node(ROOT + "/Note").notes,
				"narrator": get_node(ROOT + "/Box Controls").narrator,
				"centered": get_node(ROOT + "/Box Controls").centered, 
				"interrupt": get_node(ROOT + "/Box Controls").interrupt,
				"divert": divert,
				"previous": previous,
				"options": [get_node(ROOT + "/Options/Option1").text, 
					get_node(ROOT + "/Options/Option2").text, 
					get_node(ROOT + "/Options/Option3").text],
				"settings": get_node(ROOT).markerList.duplicate(true),
				
			}
		]}

	elif (options == 1):
		info = {
			"content": [
			get_node(ROOT).currDia.c_escape(), # text
			{
				"name": get_node(ROOT + "/Name box/TextEdit").text,
				"note": get_node(ROOT + "/Note").notes,
				"narrator": get_node(ROOT + "/Box Controls").narrator,
				"centered": get_node(ROOT + "/Box Controls").centered, 
				"interrupt": get_node(ROOT + "/Box Controls").interrupt,
				"divert": divert,
				"previous": previous,
				"options": [get_node(ROOT + "/Options/Option1").text, 
					get_node(ROOT + "/Options/Option2").text, 
					get_node(ROOT + "/Options/Option3").text],
				"settings": get_node(ROOT).markerList.duplicate(true),
				
			},
			{
				"option": get_node(ROOT + "/Options/Option1").text,
				"linkpath": optText[0]
			}
		]}
	elif (options == 2):
		info = {
			"content": [
			get_node(ROOT).currDia.c_escape(), # text
			{
				"name": get_node(ROOT + "/Name box/TextEdit").text,
				"note": get_node(ROOT + "/Note").notes,
				"narrator": get_node(ROOT + "/Box Controls").narrator,
				"centered": get_node(ROOT + "/Box Controls").centered, 
				"interrupt": get_node(ROOT + "/Box Controls").interrupt,
				"divert": divert,
				"previous": previous,
				"options": [get_node(ROOT + "/Options/Option1").text, 
					get_node(ROOT + "/Options/Option2").text, 
					get_node(ROOT + "/Options/Option3").text],
				"settings": get_node(ROOT).markerList.duplicate(true),
				
			},
			{
				"option": get_node(ROOT + "/Options/Option1").text,
				"linkpath": optText[0]
			},
			{
				"option": get_node(ROOT + "/Options/Option2").text,
				"linkpath": optText[1]
			},
		]}
	elif (options == 3):
		info = {
			"content": [
			get_node(ROOT).currDia.c_escape(), # text
			{
				"name": get_node(ROOT + "/Name box/TextEdit").text,
				"note": get_node(ROOT + "/Note").notes,
				"narrator": get_node(ROOT + "/Box Controls").narrator,
				"centered": get_node(ROOT + "/Box Controls").centered, 
				"interrupt": get_node(ROOT + "/Box Controls").interrupt,
				"divert": divert,
				"previous": previous,
				"options": [get_node(ROOT + "/Options/Option1").text, 
					get_node(ROOT + "/Options/Option2").text, 
					get_node(ROOT + "/Options/Option3").text],
				"settings": get_node(ROOT).markerList.duplicate(true),
				
			},
			{
				"option": get_node(ROOT + "/Options/Option1").text,
				"linkpath": optText[0]
			},
			{
				"option": get_node(ROOT + "/Options/Option2").text,
				"linkpath": optText[1]
			},
			{
				"option": get_node(ROOT + "/Options/Option3").text,
				"linkpath": optText[2]
			}
		]}
		
	varValueCheck("name", get_node(ROOT + "/Name box/TextEdit").text, "")
	varValueCheck("note", get_node(ROOT + "/Note").notes, "")
	varValueCheck("narrator", get_node(ROOT + "/Box Controls").narration, false)
	varValueCheck("centered", get_node(ROOT + "/Box Controls").centered, false)	
	varValueCheck("interrupt", get_node(ROOT + "/Box Controls").interrupt, false)
		
	optText.clear()
	
func varValueCheck(key, value, default):
	if (value != default):
		if (key == "narrator"):
			info["content"][1][key] = get_node(ROOT + "/Box Controls").narrator.duplicate(true)
		else:
			info["content"][1][key] = value
	else:
		info["content"][1].erase(key)
	
func getOptionCount():
	var optionCount = 0
	if (option1 != ""):
		optionCount += 1
		optText.append(option1)
	if (option2 != ""):
		optionCount += 1
		optText.append(option2)
	if (option3 != ""):
		optionCount += 1
		optText.append(option3)
	return optionCount

# Called before page is saved to file. Because there's a lot of pointer
# menipulation with pages when they're not on screen, we need to make sure
# that the info values are updated to match the local values. Otherwise
# the file would only get outdated info based on the last time the page was visible
func updateFileValues():
	
	var options = getOptionCount()
	
	info["content"][1]["divert"] = divert
	info["content"][1]["previous"] = previous
	if (options == 1):
		info["content"][2]["linkpath"] = optText[0]
	elif (options == 2):
		info["content"][2]["linkpath"] = optText[0]
		info["content"][3]["linkpath"] = optText[1]
	elif (options == 3):
		info["content"][2]["linkpath"] = optText[0]
		info["content"][3]["linkpath"] = optText[1]
		info["content"][4]["linkpath"] = optText[2]
		
	optText.clear()
