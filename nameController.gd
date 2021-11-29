extends Sprite


func _ready():
	pass # Replace with function body.



func _on_TextEdit_text_entered(new_text):
	get_node("TextEdit").release_focus()
	get_node("../TextDrawer").update_text()

