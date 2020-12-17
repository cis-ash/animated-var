extends Node2D

var char_disabled = false

onready var hand_l     = $detonator/pump/left_hand
onready var hand_r     = $detonator/pump/right_hand
onready var shoulder_l = $chick/shoulder_left
onready var shoulder_r = $chick/shoulder_right
onready var elbow_l    = $chick/shoulder_left/lower_left
onready var elbow_r    = $chick/shoulder_right/lower_right
onready var leg_l      = $chick/leg_left
onready var leg_r      = $chick/leg_right
onready var pump       = $detonator/pump

onready var segment_length = (shoulder_l.global_position-elbow_l.global_position).length()
var distance_to_target = 0.0

var leg_angle = 0.0;
var leg_speed = 0.0;
var pump_position = -190.0;
var pump_idle = -190;
var pump_bottom = -130;
var pump_speed = 0.0;
var chick_position = Vector2(0,0);
var chick_speed = Vector2(0,0);

func set_is_disabled(new_value : bool):
	$character_hider.set_is_disabled(new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	if char_disabled:
#		return
	if Input.is_action_just_pressed("e"): trigger_animation()
	
	idle_animation(delta)
	
	do_the_arm_bendy_thing()
	pass

func trigger_animation():
	leg_speed += 1000;
	pump_speed += 2000;
	chick_speed += Vector2(rand_range(-500,500), -800)
	pass

func idle_animation(delta):
	leg_speed = lerp(leg_speed, -leg_angle*20, delta*5);
	leg_angle += leg_speed*delta;
	if leg_angle <= -10:
		leg_angle = -10;
		leg_speed *= -0.7;
	
	leg_l.rotation_degrees = leg_angle;
	leg_r.rotation_degrees = -leg_angle;
	
	pump_speed = lerp(pump_speed, (pump_idle-pump_position)*20,delta*10);
	pump_position += pump_speed*delta;
	if pump_position >= pump_bottom:
		pump_position = pump_bottom;
		pump_speed *= -0.7;
	
	pump.position.y = pump_position 
	
	chick_speed = lerp(chick_speed, (-chick_position-Vector2(0,pump_position-pump_idle -15))*20, delta*10);
	chick_position += chick_speed*delta;
	if chick_position.y -pump_position + pump_idle < -80:
		chick_position.y = pump.position.y-pump_idle-80;
		chick_speed.y *= 0.5;
	$chick.position = chick_position
	




func do_the_arm_bendy_thing():
	var distance = (shoulder_l.global_position - $detonator/pump/left_hand.global_position).length()
	var angle = asin(sqrt(segment_length*segment_length - (distance*distance)/4)/segment_length)
	if distance >= 2*segment_length:
		angle = 0;
	shoulder_l.look_at($detonator/pump/left_hand.global_position)
	shoulder_l.rotation += PI + angle
	elbow_l.rotation = (-2*angle)
	
	distance = (shoulder_r.global_position - $detonator/pump/right_hand.global_position).length()
	angle = asin(sqrt(segment_length*segment_length - (distance*distance)/4)/segment_length)
	if distance >= 2*segment_length:
		angle = 0;
	shoulder_r.look_at($detonator/pump/right_hand.global_position)
	shoulder_r.rotation -= angle
	elbow_r.rotation = (2*angle + PI)
	pass
