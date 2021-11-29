extends ConfirmationDialog

var fileNameEmpty = true
var objNameEmpty = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_New_pressed():
	self.popup_centered()
	# undisable it when we enter a name for a file that doesn't already exist
	self.get_ok().disabled = true 


# Use this to look for duplicate files and prevent overriding with it
func _on_File_Name_text_changed(new_text):

	if (new_text.length() > 0):
		fileNameEmpty = false
	else:
		fileNameEmpty = true
	testOk()
	



func _on_Object_Name_text_changed(new_text):

	if (new_text.length() > 0):
		objNameEmpty = false
	else:
		objNameEmpty = true
	testOk()
		
func testOk():
	# neither are empty
	if (!fileNameEmpty && !objNameEmpty):
		self.get_ok().disabled = false
	else:
		self.get_ok().disabled = true 
