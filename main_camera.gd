extends Camera2D
var page = 0
var pos = 500
var speed = 0
var min_page = 0
var max_page = 4


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	var target = 500 + page*1000
	speed = lerp(speed, (target-pos)*20, delta*20)
	pos += speed*delta
	if pos < min_page*1000:
		page = min_page
	if pos > (max_page+1)*1000:
		page = max_page
	global_position.x = pos
	pass


func _on_left2_clicked():
	pass # Replace with function body.
