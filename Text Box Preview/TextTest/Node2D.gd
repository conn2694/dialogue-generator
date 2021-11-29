extends Node2D



var loadText = preload("res://Text Box Preview/TextBubbles.tscn")
var loadPreview = loadText.instance()
var previewText = loadPreview.get_node("CanvasLayer/Label")
var textAmount = 0
var textBoxFreed = false
var textBoxMade = false

var jsonTest = {}

# load bg image if we have one
func _ready():
	if (get_node("../BG").bg == "None"):
		return
		
	var tex = ImageTexture.new()
	var image = Image.new()
	print("path: ", GLOBALS.BG_PATH + "/" + get_node("../BG").bg)
	var err = image.load(GLOBALS.BG_PATH + "/" + get_node("../BG").bg + ".png")
	if err != OK:
		print("didn't work")
	tex.create_from_image(image)
	get_node("BG").texture = tex
		

func loadPreview(file, object, page=""):
	previewText.newText(file, object, page)
	add_child(loadPreview)


func _on_Close_pressed():
	get_node("..").triggerPreview()
