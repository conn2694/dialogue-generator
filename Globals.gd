extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PORTRAIT_PATH
var SOUND_PATH
var MUSIC_PATH
var PICTURE_PATH
var BG_PATH

# Called when the node enters the scene tree for the first time.
func _init():
	PORTRAIT_PATH = loadPath("portraitpath.txt")
	SOUND_PATH = loadPath("sfxpath.txt")
	MUSIC_PATH = loadPath("musicpath.txt")
	PICTURE_PATH = loadPath("picpath.txt")
	BG_PATH = loadPath("bgpath.txt")
	
func loadPath(path):
	var file = File.new()
	file.open("paths/" + path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
