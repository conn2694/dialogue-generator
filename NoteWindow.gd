extends AcceptDialog



func _ready():
	# change the name from "ok" to "Save"
	self.get_ok().text = "Save"



func _on_Button_pressed():
	self.popup_centered()
	self.show_on_top = true
