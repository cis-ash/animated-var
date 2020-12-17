extends Node2D

var hover = false;
var dragged = false;
onready var top_end = $top.position.y
onready var bottom_end = $bottom.position.y
var slider_position = top_end
var visual_slider_speed = 0.0;
var visual_slider_position = 0.0;
var value = 0.0; # OUTSIDE WORLD 2 WAY INTERRACTION VARIABLE, RANGE FROM 0 TO 1
var was_dragged = false;
var total_steps = 10.0
var current_step = 0.0

signal dragged(value)

func set_value_silent(new_value):
	value = new_value

func _ready():
	pass

func _physics_process(delta):
	bottom_end = $bottom.position.y
	was_dragged = dragged
	#debug hover displayer
	if dragged:
		$slider/slidertop.self_modulate = Color(1,0.5,0)
	else:
		$slider/slidertop.self_modulate = Color(1,0,0.5)
	
	if dragged:
		slider_position = get_local_mouse_position().y
		slider_position = clamp(slider_position,top_end,bottom_end)
		value = (slider_position-top_end)/(bottom_end - top_end)
		emit_signal("dragged", value)
#		print(value)
		if abs(value - current_step) > 1/total_steps:
			current_step = value
#			print(value)
			$AudioStreamPlayer.pitch_scale = lerp(0.75,3, 1-value)
			$AudioStreamPlayer.play()
	else:
		#move slider to target position
		slider_position = top_end + value*(bottom_end - top_end)
	
	#move slider
	visual_slider_speed = lerp(visual_slider_speed, (slider_position- visual_slider_position)*30, delta*20)
	visual_slider_position += visual_slider_speed * delta;
	if (visual_slider_position < top_end)||(visual_slider_position > bottom_end):
		visual_slider_speed *= -0.5;
		visual_slider_position = clamp(visual_slider_position,top_end,bottom_end)
	
	$slider.position.y = visual_slider_position
	$slider.scale = Vector2(pow(1.1,visual_slider_speed/400), pow(1.1,-(visual_slider_speed/400)));
	
	if Input.is_action_just_pressed("click") && hover:
		dragged = true
	
	if Input.is_action_just_released("click"):
		dragged = false
	
	if !was_dragged && dragged:
		$grab.play()
	
	if was_dragged && !dragged:
		$release.play()
	
	#debug function, disable later
	#if Input.is_action_just_pressed("poke"):
	#	value = rand_range(0.0,1.0)
	
	pass 


func _on_Area2D_mouse_entered():
	hover = true;
	pass


func _on_Area2D_mouse_exited():
	hover = false
	pass
