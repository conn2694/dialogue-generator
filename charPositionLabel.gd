extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DEFAULT_LT1 = 2
const DEFAULT_RT1 = 30
const DEFAULT_LT2 = 5
const DEFAULT_RT2 = 27


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Position_value_changed(value):
	var pos = ""
	var half = int((get_node("..").max_value + 1) / 2)

	
	match int(value):
		DEFAULT_LT1:
			pos = "LT1"
		DEFAULT_LT2:
			pos = "LT2"
		DEFAULT_RT1:
			pos = "RT1"
		DEFAULT_RT2:
			pos = "RT2"
		half:
			pos = "Center"
		_:
			pos = str(value)
	
	self.text = "Pos: " + pos
		
