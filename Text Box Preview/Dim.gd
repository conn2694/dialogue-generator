extends Node2D

var dimmed = false
# for in case we start out with a dimmed scene
func startDim():
	get_node("AnimationPlayer").play("Dim")
	dimmed = true

func endDim():
	get_node("AnimationPlayer").play_backwards("Dim")
	dimmed = false

# for every time we reach a new marker or page
func updateDim(dim):
	if (dim && !dimmed):
		get_node("AnimationPlayer").play("Dim")
		dimmed = true
	elif (!dim && dimmed):
		get_node("AnimationPlayer").play_backwards("Dim")
		dimmed = false
