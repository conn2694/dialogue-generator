extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const NUM_POSITIONS = 32
const PORTRAIT_SIZE = 192
const PORTRAIT_RANGE = 120 # how much we can overlap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	updateSprite("portraits/Joshua/josh_1.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateSprite(file):
	var tex = ImageTexture.new()
	var image = Image.new()
	var err = image.load(file)
	if err != OK:
		print("didn't work")
	tex.create_from_image(image)
	self.texture = tex

func hide():
	self.visible = false

func show():
	self.visible = true
	
func setPosition(pos):
	self.position.x = convertToScreenPosition(pos)
	
func flipped(val):
	self.flip_h = val

func convertToScreenPosition(value):
	
	# We want the width of the screen, the size of two halves of a portrait so they'd
	# both be in frame, and then the range to stretch it out
	var num = get_viewport_rect().size.x - PORTRAIT_SIZE + (PORTRAIT_RANGE)
	# Segments out coordinates in sets of our numbered position, and then
	# multiplies the value to pick one of those positions
	num /= NUM_POSITIONS
	num *= value
	# because we shrink the size in the first part, we want to 
	# create an offset to center the array of positions
	# (if we get half of NUM_POSITION, we will get the center of the screen)
	num += (PORTRAIT_SIZE - PORTRAIT_RANGE) * 0.5	# offset to center it
	return int(num)
