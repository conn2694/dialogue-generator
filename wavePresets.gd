extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var presets = []


# Called when the node enters the scene tree for the first time.
func _ready():

	
	var preFile = File.new()
	preFile.open("presets/wave.json", File.READ)
	var preList = parse_json(preFile.get_as_text())
	preFile.close()
	
	for preset in preList:
		self.add_item(preset["name"])
		presets.append(preset)
	

func add(title):
	var newPreset = {
		"name": title,
		"amp": get_node("../Amp/HSlider").value,
		"wave": get_node("../Wave/HSlider").value,
		"pi": get_node("../Pi/HSlider").value
	}
	self.presets.append(newPreset)

	var file = File.new()
	file.open("presets/wave.json", File.WRITE)
	file.store_string(JSON.print(self.presets, "\t"))
	file.close()

