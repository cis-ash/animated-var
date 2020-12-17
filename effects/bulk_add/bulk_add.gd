extends Node2D


var index := 0 #set this when spawning
var text := "UUUUUUUUUUUUUUUUWWUUUUUUUUUUUUUUUU" #set this when spawning
var last_letter_position := Vector2()
var render_offset := 0.0

var speed := 0.0
var pos := 0.0 
var grav := 4000.0
var squash := 0.0
var squash_speed := 0.0
var timer := 0.0
var color_array := [Color(1,0,0.5),Color(1,0.5,0),Color(0,1,0.5),Color(0.5,1,0),Color(0,0.5,1),Color(0.5,0,1)]
var flash_color := Color()

onready var blur_node : Label = $scaler/blur
onready var shadow_node : Label = $scaler/shadow
onready var top_node : Label = $scaler/top

var time_alive = 0.0
const life_time = 0.48

func _ready():
	start_sequence()
	yield(get_tree(), "idle_frame")
	
	blur_node.rect_position.x = -blur_node.rect_size.x * 0.5 * blur_node.rect_scale.x
	
	shadow_node.rect_position.x = -shadow_node.rect_size.x * 0.5
	shadow_node.rect_position += Vector2(
		ProjectSettings.get_setting("textreme/editor/shadow_offset_x"),
		ProjectSettings.get_setting("textreme/editor/shadow_offset_y")
	)
	
	shadow_node.set("custom_colors/font_color",
		ProjectSettings.get_setting("textreme/editor/font_shadow_color"))
	top_node.rect_position.x = -top_node.rect_size.x * 0.5
	
	var rect_end : Vector2 = top_node.rect_position + top_node.rect_size
	var rect_no_scale := rect_end
	
	position = last_letter_position - rect_no_scale
	
	$"white square".position = top_node.rect_position + top_node.rect_size/2
	$"white square".scale = top_node.rect_size / 128.0
	$"white square".self_modulate = ProjectSettings.get_setting("textreme/editor/font_background_color")
	
#	Engine.time_scale = 0.1
	
#	if index == 0:
#		return
	
#	var time_to_wait = 0.5/(1 + index * 0.2)
#	$scaler.hide()
#	set_process(false)
#	yield(get_tree().create_timer(time_to_wait), "timeout")
#	$scaler.show()
#	set_process(true)
	

func _physics_process(delta):
	process_falling(delta)
	time_alive += delta

func process_falling(delta : float):
	squash_speed = lerp(squash_speed, -squash*20, delta*30)
	squash += squash_speed * delta
	$scaler.scale = Vector2(pow(1.3,squash), pow(1.3, -squash))
	speed += delta * grav
	pos += speed * delta
	if pos >= 0.0:
		pos = 0.0
		if blur_node.visible:
			speed = -400
			squash = 1
			squash_speed = 20
			timer = 0.2
		else:
			speed *= -0.7
			speed = min(0, speed+30)
			if time_alive >= life_time || is_zero_approx(speed):
				queue_free()
		blur_node.visible = false
	
	timer = max(timer - delta, 0)
	var font_color = ProjectSettings.get_setting("textreme/editor/font_color")
	top_node.set("custom_colors/font_color",
		lerp(font_color, flash_color, timer/0.2))
	$scaler.position.y = pos
	


func start_sequence():
	pos = -500
	speed = 3000
	squash_speed = 0
	squash = 0
	blur_node.visible = true
	blur_node.text = text
	shadow_node.text = text
	top_node.text = text
	
	var soundname := "pop"+str(randi()%9)
#	get_node(soundname).pitch_scale = 1 + index*0.15
	if index < 10:
		get_node(soundname).play()
	flash_color = color_array[randi()%color_array.size()]
