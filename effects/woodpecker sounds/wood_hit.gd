extends Node2D

var clip_id = randi()%7
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("hit_" + str(clip_id)).playing = true
	get_node("hit_" + str(clip_id)).volume_db = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("hit_"+str(clip_id)).playing == false:
		queue_free()
		#print(str(clip_id))
	pass
