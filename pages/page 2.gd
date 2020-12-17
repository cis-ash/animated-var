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


func _on_slider_dragged(value):
	$Node2D.position = lerp(Vector2.ZERO,$Position2D.position,value)
	pass # Replace with function body.
