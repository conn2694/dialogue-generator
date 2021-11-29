extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playButton = preload("res://theme/play_button.png")
var pauseButton = preload("res://theme/pause_button.png")
enum {PLAY, PAUSE}
var currState = PAUSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_TextureButton_pressed():
	
	match currState:
		# prematurely end the play
		PLAY:
			get_node("TextureButton").texture_normal = playButton
			currState = PAUSE
			get_node("../TextDrawer").visibleText = get_node("..").totalLetters

			get_node("../TextDrawer").waveModulator = 0
			get_node("../TextDrawer").update_text()
			for i in range(get_node("../TextDrawer/Markers").get_child_count()):
				get_node("../TextDrawer/Markers").get_child(i).visible = true
			
			
		# pressing play
		PAUSE:
			get_node("TextureButton").texture_normal = pauseButton
			currState = PLAY
			get_node("../TextDrawer").visibleText = 0
			# we may have some pausing first, so use that
			get_node("../Speed/Timer").wait_time = get_node("..").markerList[0]["pause"] if get_node("..").markerList[0].has("pause") else 0
			get_node("../Speed/Timer").start()
			get_node("../Speed").markIter = 0
			for i in range(get_node("../TextDrawer/Markers").get_child_count()):
				get_node("../TextDrawer/Markers").get_child(i).visible = false

			
