extends Control

var pageScene = preload("res://page.tscn") #preload to have it right away
var objScene = preload("res://object.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_CurrentFile_item_selected(0)

func initMarker():
	var markerArray = []
	var marker = {
		"mark": 0,
		#"pi": 1,
		#"wave": 0,
		#"amp": 0,
		#"color": Color("ffffff").to_html(false),
		#"speed": 0.01,
		#"chars": 1,
		"sound": "02_fluttery",
		#"pause": 0,
		"portraits": {},
		#"sfx": "None",
		#"shock": false,
		#"dim": false
	}
	markerArray.append(marker)
	return markerArray

func get_initial_page():
	var info = {
		"content": [
		"", # empty text
		{
			#"name": "", # resetControls initializes this to empty string
			#"note": "",
			"divert": "",
			"previous": "",
			#"narrator": false,
			#"centered": false, 
			#"cutoff": "normal",
			"options": ["", "", ""],
			# May need to populate this init values for the controls if there are errors
			"settings": initMarker(), 
			
		}
	]}
	return info

func _on_CreateFile_confirmed():
	
	# make a small template here to save into the file with object we chose being
	
	var objName = get_node("CreateFile/Container/Object Name").text

	
	# make object in file
	var page = {
		"initial": objName,
		"pageCount": 0,
		objName: get_initial_page()
	}
	var object = {
		objName: page
	}
	var data = {
		"data": object
	}
	
	saveFile(get_node("CreateFile/Container/File Name").text, JSON.print(data, "\t"))
	
	get_node("CurrentFile").add_item(get_node("CreateFile/Container/File Name").text)
	
	var id = 0
	while (get_node("CurrentFile").get_item_text(id) != ""):
		if (get_node("CurrentFile").get_item_text(id) == get_node("CreateFile/Container/File Name").text):
			get_node("CurrentFile").select(id)
			_on_CurrentFile_item_selected(id)
			break
		id += 1
		

	
	
	# switch to the new file after and create the object the player wrote down


func saveFile(fileName, data):
	
	var dir = Directory.new()
	dir.copy("Dialogue/" + fileName + ".json", "Dialogue/#" + fileName + ".json")
	
	var file = File.new()
	file.open("Dialogue/" + fileName + ".json", File.WRITE)
	file.store_string(data)
	file.close()
	
	
	
func loadFile(fileName):
	var file = File.new()
	file.open("Dialogue/" + fileName + ".json", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

# Saving a file
func _on_Save_pressed():
	
	# Save the current page so it's all updated before we save it to the file
	get_node("../Page").currentPage.savePage()
	var testObjects = {}
	var testPages = {}
	
	#print(get_node("../Page/Pages/test/test").divert, " ", get_node("../Page/Pages/test/test")["info"]["content"][1]["divert"])

	# Objects
	for i in get_node("../Page/Pages/").get_children():
		testPages["initial"] = i.initial
		testPages["pageCount"] = i.pageCount
		# Pages
		for j in i.get_children():
			j.updateFileValues()
			print("divert: ", j["info"]["content"][1]["divert"])
			testPages[j.name] = j.info
		testObjects[i.name] = testPages.duplicate(true)
		# reinitialize so other objects don't have the same pages carried over
		testPages = {}
		

	var data = {
		"data": testObjects
	}

	# save current file
	saveFile(get_node("CurrentFile").get_item_text(get_node("CurrentFile").get_selected_id()), JSON.print(data, "\t"))
	
	
	for i in range (data.values()[0].size()):
		print(data.values()[0].values()[0].values()[0])


# Switching files
func _on_CurrentFile_item_selected(index):
	
	# Get ready, save the page
	get_node("../Page").buttonPressed = true
	get_node("../Page").currentPage.savePage()
	
	# Make sure to save the file before switching
	#_on_Save_pressed()
	
	# Clear all the objects
	for i in get_node("../Page/Pages").get_children():
		i.free()
	get_node("../Object/CurrentObject").clear()
	
	#while (get_node("../Page/Pages").get_child_count() > 0):
	#	pass
	
	# Read from file
	var fileName = get_node("CurrentFile").get_item_text(index)
	var data = JSON.parse(loadFile(fileName)).result
	
	# go through every object
	var objCount = 0 
	var pageCount = 0
	for i in range(data.values()[0].size()):
		# create object
		pageCount = 0
		var pageFolder = objScene.instance()
		pageFolder.name = data.values()[0].keys()[i]
		pageFolder.initial = data.values()[0].values()[i]["initial"]
		pageFolder.pageCount = data.values()[0].values()[i]["pageCount"]
		get_node("../Page/Pages").add_child(pageFolder)
		get_node("../Object/CurrentObject").add_item(pageFolder.name)
		
		#create pages for the object
		for j in range(2, data.values()[0].values()[i].values().size()):
			var pageInstance = pageScene.instance()
			var pageName = data.values()[0].values()[i].keys()[j]
			get_node("../Page/Pages/" + pageFolder.name).add_child(pageInstance)
			# Make sure the page is loaded and initialized before we start writing to it
			while (!get_node("../Page/Pages/" + pageFolder.name + "/Node").ready):
				pass
			pageInstance.name = pageName
			pageInstance.divert = data.values()[0].values()[i].values()[j]["content"][1]["divert"]
			pageInstance.previous = data.values()[0].values()[i].values()[j]["content"][1]["previous"]
			
			# fill up the options
			if (data.values()[0].values()[i].values()[j]["content"].size() > 2):

				for k in range(2, data.values()[0].values()[i].values()[j]["content"].size()):
					if (k == 2):
						pageInstance.option1 = data.values()[0].values()[i].values()[j]["content"][k]["linkpath"]
					if (k == 3):
						pageInstance.option2 = data.values()[0].values()[i].values()[j]["content"][k]["linkpath"]
					if (k == 4):
						pageInstance.option3 = data.values()[0].values()[i].values()[j]["content"][k]["linkpath"]
			
			pageInstance.info = data.values()[0].values()[i].values()[j]

			pageCount += 1
		while (get_node("../Page/Pages/" + pageFolder.name).get_child_count() < pageCount):
			pass
	# wait for them all to load

	
	# switch to the first value
	var initObj = get_node("../Page/Pages").get_child(0)
	var initPage = get_node("../Page/Pages/" + initObj.name + "/" + initObj.initial)
	get_node("../Page").currObject = initObj.name
	get_node("../Page").currentPage = initPage
	get_node("../Page").checkButtons()
	get_node("../Page").updateControls()
	get_node("../Page").unfocus()
	get_node("../Page/CurrentPage").text = "pg 1"
	get_node("../Page").buttonPressed = false
	

	
		
		
