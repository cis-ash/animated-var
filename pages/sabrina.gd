extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_button_clicked():
	OS.shell_open("https://sabrina-tvband.itch.io/")
	pass # Replace with function body.


func _on_music_clicked():
	OS.shell_open("https://tvband.bandcamp.com/")
	pass # Replace with function body.


func _on_twitter_clicked():
	OS.shell_open("https://twitter.com/sabrinatvband")
	pass # Replace with function body.
