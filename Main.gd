extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		$main_camera.page -= 1;
	if Input.is_action_just_pressed("ui_right"):
		$main_camera.page += 1;
	pass


func _on_right_clicked():
	$main_camera.page += 1;
	pass # Replace with function body.


func _on_left_clicked():
	$main_camera.page -= 1;
	pass # Replace with function body.


func _on_left2_clicked():
	get_tree().quit()
	pass # Replace with function body.
