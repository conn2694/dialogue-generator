extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Option1_text_entered(new_text):
	get_node("Option1").release_focus()
	get_node("../TextDrawer").update_text()


func _on_Option2_text_entered(new_text):
	get_node("Option2").release_focus()
	get_node("../TextDrawer").update_text()


func _on_Option3_text_entered(new_text):
	get_node("Option3").release_focus()
	get_node("../TextDrawer").update_text()
