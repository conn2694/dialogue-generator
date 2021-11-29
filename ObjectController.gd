extends Control


var pageScene = preload("res://page.tscn") #preload to have it right away
var objScene = preload("res://object.tscn")
var objectLocations = null

# Get all the objects of the initial file
func _ready():
	objectLocations = get_node("../Page/Pages")
	for i in objectLocations.get_children():
		get_node("CurrentObject").add_item(i.name)




# When the new option is created
func _on_CreateObject_confirmed():
	
	get_node("../Page").buttonPressed = true
	var currObj = get_node("CurrentObject").get_item_text(get_node("CurrentObject").get_selected_id())
	var newObj = ""
	
	# Save our last page before moving to the new one
	get_node("../Page").currentPage.savePage()
	get_node("../Page").resetControls()
	
	# Add to list
	newObj = get_node("CreateObject/Container/LineEdit").text
	get_node("CurrentObject").add_item(newObj)
	
	# Create the new object and page and switch to it
	var pageFolder = objScene.instance()
	pageFolder.name = newObj
	get_node("../Page/Pages").add_child(pageFolder)
	var pageInstance = pageScene.instance()
	pageInstance.name = newObj
	get_node("../Page/Pages/" + newObj).add_child(pageInstance)
	get_node("../Page").currentPage = pageInstance
	get_node("../Page").initialPage = get_node("../Page").currentPage
	pageFolder.initial = get_node("../Page").currentPage.name
	get_node("../Page").currObject = newObj
	
	#update things in the page like the page count and controls
	get_node("../Page/CurrentPage").text = "pg 1"
	get_node("../Page").checkButtons()
	get_node("../Page").updateControls()
	get_node("../Page").unfocus()
	get_node("../Page").buttonPressed = false
	
	# select our new object
	var id = 0
	while (get_node("CurrentObject").get_item_text(id) != ""):
		if (get_node("CurrentObject").get_item_text(id) == newObj):
			get_node("CurrentObject").select(id)
			break
		id += 1


# Switch from one object to another
func _on_CurrentObject_item_selected(index):
	
	var objName = get_node("CurrentObject").get_item_text(index)

	# since we're going back to init page, just start at pg 1
	get_node("../Page/CurrentPage").text = "pg 1"
	get_node("../Page").buttonPressed = true
	get_node("../Page").currentPage.savePage()
	# hacky, when we make an "object" node we'll use the initial node value for the last variable
	get_node("../Page").currentPage = get_node("../Page/Pages/" + objName + "/" + objName)
	get_node("../Page").currObject = objName
	get_node("../Page").currObjName = objName
	get_node("../Page").initialPage = get_node("../Page").currentPage
	get_node("../Page").checkButtons()
	get_node("../Page").updateControls()
	get_node("../Page").unfocus()

	get_node("../Page").buttonPressed = false

func getCurrentObject():
	return get_node("CurrentObject").get_item_text(get_node("CurrentObject").selected)
