extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_LineEdit_text_entered(new_text):
	get_node("Main/ColorRect").color = Color(get_node("Main/LineEdit").text)
	get_node("..").updateMarker()
	get_node("Main/LineEdit").release_focus()
	get_node("../TextDrawer").update_text()
	
