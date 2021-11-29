extends Sprite


# for in case we start out with a character entering
func slide_in():
	get_node("AnimationPlayer").play("Slide In")


func slide_out():
	get_node("AnimationPlayer").play_backwards("Slide In")

# for every time we reach a new marker or page
func updateName(charName, previousCharName):
	# no character talking
	print("charname: ", charName, "\tpreviousname: ", previousCharName)
	if (charName == ""):
		if (previousCharName == ""):
			pass
		else:
			get_node("AnimationPlayer").play_backwards("Slide In")
	# different character
	elif (charName != previousCharName):
		get_node("Name").text = charName
		get_node("AnimationPlayer").play("Slide In")


