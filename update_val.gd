extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_HSlider_value_changed(value):
	self.text = str(get_node("..").value)
	get_node("../../../..").updateMarker()

