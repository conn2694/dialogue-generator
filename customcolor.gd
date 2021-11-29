extends ColorPicker


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():

	get_node("@@2").visible = false
	#get_node("@@5/@@7").visible = false
	get_node("@@8").visible = false
	get_node("@@9").visible = false
	get_node("@@10/@@19").visible = false
	get_node("@@10/@@28").visible = false
	get_node("@@10/@@37").visible = false
	get_node("@@10/@@47/@@48").visible = false
	get_node("@@10/@@47/@@49").visible = false
	get_node("@@56").visible = false
	get_node("@@58").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("@@10/@@47/@@54").margin_right = 80
