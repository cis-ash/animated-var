extends Node2D

var state = false;
var hover = false;

var indicator_pos = 0.0;
var indicator_speed = 0.0;

export var default = false;

export var off_back = Color(0.5,0.25,0.25);
export var off_indicator = Color(1,0.5,0);

export var on_back = Color(0,0.5,0.25);
export var on_indicator = Color(0,1,0.5);

onready var off_pos = $off.position.x
onready var on_pos = $on.position.x

func _ready():
	state = default;
	pass # Replace with function body.


func _physics_process(delta):
	
	if hover && Input.is_action_just_released("click"):
		state = !state;
		$AudioStreamPlayer.play()
	
	if state:
		indicator_speed = lerp(indicator_speed, (on_pos-indicator_pos)*30, delta*20);
	else:
		indicator_speed = lerp(indicator_speed, (off_pos-indicator_pos)*30, delta*20);
	
	indicator_pos += indicator_speed*delta
	
	if (indicator_pos > on_pos)||(indicator_pos < off_pos):
		indicator_speed *= -0.8;
		indicator_pos = clamp(indicator_pos, off_pos, on_pos)
	
	$indicator.position.x = indicator_pos
	var lerpy_value = (indicator_pos-off_pos)/(on_pos-off_pos)
	
	$field.self_modulate = lerp(off_back, on_back, lerpy_value)
	$indicator/top.self_modulate = lerp(off_indicator, on_indicator, lerpy_value)
	
	pass


func _on_Area2D_mouse_entered():
	hover = true;
	pass

func _on_Area2D_mouse_exited():
	hover = false;
	pass
