extends Control



enum  {
	NORMAL,
	INTERUPT,
	CUTOFF
}
var currBoxState = NORMAL
export var boxCuttoffType = "normal"
export var narration = false # just a bool to see if we need narration
export var narrator = {} # actual narration data
export var centered = false
export var shocked = false
export var dimmed = false
export var prompted = false
export var interrupt = false
const normalBtn = preload("res://theme/normal_box_button.png")
const interuptBtn = preload("res://theme/interupt_button.png")
const cutoffBtn = preload("res://theme/cutodd_button.png")
const normalHint = "Normal End:\nRequires button prompt from player to move forward"
const interuptHint = "Interupt End:\nPage automatically moves forward after reaching the end"
const cutoffHint = "Cutoff End:\nPage automatically cancels the whole dialogue at the end"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Narration_toggled(button_pressed):
	if (button_pressed):
		narration = true
		get_node("Narration/Clear Narration").visible = true
		get_node("Narration/Clear Normal").visible = true
		get_node("Narration/Continue Normal").visible = true
	else:
		get_node("Narration/Clear Narration").pressed = false
		get_node("Narration/Clear Normal").pressed = false
		get_node("Narration/Continue Normal").pressed = false
		get_node("Narration/Clear Narration").visible = false
		get_node("Narration/Clear Normal").visible = false
		get_node("Narration/Continue Normal").visible = false
		get_node("Narration").clearAll()
		narration = false

	get_node("..").updateMarker()
func _on_Centered_toggled(button_pressed):
	centered = button_pressed
	get_node("..").updateMarker()
func _on_Shock_toggled(button_pressed):
	shocked = button_pressed
	get_node("..").updateMarker()
func _on_Dim_toggled(button_pressed):
	dimmed = button_pressed
	get_node("..").updateMarker()
	
func updateValueswithControls():
	narration = get_node("Narration").pressed
	centered = get_node("Centered").pressed
	get_node("Narration").updateValueswithControls()

# These get update when we change pages
func updateControls(centered, narration, interrupt):
	
	get_node("Centered").pressed = bool(centered)
	get_node("BoxCutoff").pressed = bool(interrupt)
	self.centered = centered
	self.interrupt = interrupt
	
	if (typeof(narration) != TYPE_BOOL):
		get_node("Narration").pressed = bool(true)
		self.narrator = narration
		self.narration = true
	else:
		get_node("Narration").pressed = bool(false)
		self.narrator = {}
		self.narration = false
	
	get_node("Narration").updateControls(narrator)
	
	
	get_node("..").updateMarker()
	
# These get update when we change markers
func updateMarkerControls(dimmed, shock, prompted):
	get_node("Dim").pressed = dimmed
	get_node("Shock").pressed = shock
	get_node("Prompt").pressed = prompted
	self.dimmed = dimmed
	self.shocked = shock
	self.prompted = prompted
	
	get_node("..").updateMarker()


func _on_Prompt_toggled(button_pressed):
	prompted = button_pressed
	get_node("..").updateMarker()


func _on_BoxCutoff_toggled(button_pressed):
	interrupt = button_pressed
	get_node("..").updateMarker()
