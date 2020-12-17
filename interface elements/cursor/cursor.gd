extends Node2D

var current_speed = Vector2()
var to_mouse = Vector2()
var last_angle = 0.0
var current_angle = 0.0
var click_scale = 0.0
var click_speed = 0.0
var click_target = 0.0

var textmode = false

func set_textmode(new_value : bool):
#	textmode = new_value
	printerr("Cursor.set_text_mode: This function is depricated, ", 
		"please dont call it")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	textmode = (Input.get_current_cursor_shape() == Input.CURSOR_IBEAM)
	
	if Input.is_action_just_pressed("click"): 
		click_target = -1
	if Input.is_action_just_released("click"):
		click_target = 0.0
		click_speed = 200
	
	$speed_squisher/sprite.visible = !textmode
	#$speed_squisher/Text_cursor.visible = textmode
	
	move_to_mouse(delta)
	scronch(delta)
	pass

func move_to_mouse(delta):
	
	var mouse = get_global_mouse_position()
	current_speed = to_mouse
	to_mouse = mouse - global_position

	to_mouse = lerp (current_speed, to_mouse, 30*delta)
	global_position += to_mouse/2
	

func scronch(delta):
	click_speed = lerp(click_speed, (click_target - click_scale)*30, 30*delta)
	click_scale += click_speed*delta
	var c_scale = pow(1.3,click_scale)
	scale = Vector2(c_scale, c_scale)
	
	
	last_angle = current_angle
	current_angle = current_speed.angle()
	$speed_squisher.global_rotation = (2*current_angle) - last_angle
	var scronch_scale = to_mouse.length() / 20000 * (3-1) /max(delta,0.01) + 1
	$speed_squisher.scale = Vector2(scronch_scale,1/scronch_scale)
	$speed_squisher/sprite.global_rotation = 0
	$speed_squisher/Text_cursor.rotation = -$speed_squisher.rotation
	
