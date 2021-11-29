extends Control


export var notes = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func checkIndicator():
	if (get_node("NoteWindow/TextEdit").text.length() == 0):
		get_node("Indicator").visible = false
	else:
		get_node("Indicator").visible = true

func _on_TextEdit_text_changed():
	# indicator to let you know if you have notes
	checkIndicator()
	notes = get_node("NoteWindow/TextEdit").text



func updateNotesByControls():
	notes = get_node("NoteWindow/TextEdit").text

func updateControls(note):
	get_node("NoteWindow/TextEdit").text = note
	notes = note
