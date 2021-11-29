extends OptionButton

var presets = []
const ROOT = "../../"

func _ready():
	var preFile = File.new()
	preFile.open("presets/global.json", File.READ)
	var preList = parse_json(preFile.get_as_text())
	preFile.close()
	
	
	for preset in preList:
		self.add_item(preset["name"])
		presets.append(preset)


func add(title):
	var newPreset = {
		"name": title,
		"waves": {
			"amp": get_node(ROOT + "Waves/Amp/HSlider").value,
			"wave": get_node(ROOT + "Waves/Wave/HSlider").value,
			"period": get_node(ROOT + "Waves/Pi/HSlider").value
		},
		"textCrawl": {
			"speed": get_node(ROOT + "Speed/Speed/HSlider").value,
			"lettersAdded": get_node(ROOT + "Speed/Chars/HSlider").value,
			"sound":  get_node(ROOT + "Speed/Sounds/Add").get_item_text(get_node(ROOT + "Speed/Sounds/Add").get_selected_id())
		},
		"globalControls": {
			"narrator": get_node(ROOT + "Box Controls").narrator if get_node(ROOT + "Box Controls").narration else false,
			"centered": get_node(ROOT + "Box Controls").centered,
			"shocked": get_node(ROOT + "Box Controls").shocked,
			"interrupt": get_node(ROOT + "Box Controls").interrupt,
			"dimmed": get_node(ROOT + "Box Controls").dimmed,
			"prompt": get_node(ROOT + "Box Controls").prompted
		},
		"sound_effect": get_node(ROOT + "Sfx").soundFx,
		"color": get_node(ROOT + "Color/Main/ColorRect").color.to_html(false),
		"delay": get_node(ROOT + "Delay/Main/HSlider").value
	}
	self.presets.append(newPreset)

	var file = File.new()
	file.open("presets/global.json", File.WRITE)
	file.store_string(JSON.print(self.presets, "\t"))
	file.close()
