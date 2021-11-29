extends ConfirmationDialog




# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("LineEdit").align = 10



func _on_Save_pressed():
	self.popup_centered()
	get_node("LineEdit").grab_focus()
