extends Node2D

var char_disabled = false

export (PackedScene) var peck_sound

func set_is_disabled(new_value : bool):
	$character_hider.set_is_disabled(new_value)

# USE peck() FUNCTION TO TRIGGER ANIMATION

func peck():
	if char_disabled:
		return
	
	neck_speed = -20;
	body_speed += 5;
	wing_speed -= 10;
	var sound = peck_sound.instance()
	sound.global_position = global_position
	add_child(sound)



#body part references
onready var leg = $leg;
onready var body = $leg/body;
onready var wing = $leg/body/wing;
onready var neck = $leg/neck;
onready var head = $leg/neck/head;
onready var pupil = $leg/neck/head/eye/pupil;
onready var beak = $leg/neck/head/beak;
onready var feathers = $leg/neck/head/feathers;

#animation variables
var neck_position = 0;
var neck_speed = 0;

var beak_position = 0;
var beak_speed = 0;

var feathers_position = 0;
var feathers_speed = 0;

var pupil_position = Vector2(0,0);
var pupil_speed = Vector2(0,0);

var body_position = 0;
var body_speed = 0;

var wing_position = 0;
var wing_speed = 0;

var leftmost_headpos = 70;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_just_pressed("w"):
		peck()
	
	var pupil_old_global = pupil.global_position;
	var beak_old_global = beak.global_rotation_degrees;
	var feathers_old_global = feathers.global_rotation_degrees;
	
	neck_speed = lerp(neck_speed, (0-neck_position)/5, delta*6);
	neck_position += neck_speed*60*delta;
	
	
	if ((head.global_position.x < (leg.global_position.x + leftmost_headpos)) && neck_speed < 0):
		neck_speed *= -1;
		neck_position = -47;
		#shake the screen on this frame
	neck.rotation_degrees = neck_position;
	
	
	pupil_speed += (pupil.global_position - pupil_old_global)/30 + Vector2(-0.2,-0.1);
	pupil_speed = lerp(pupil_speed, (Vector2(0,0) - pupil_position)/3, delta*8);
	pupil_position += pupil_speed;
	
	if pupil_position.length() > 10:
		pupil_position = pupil_position.normalized() * 10;
		pupil_speed = Vector2(0,0);
	
	pupil.position = pupil_position + Vector2(0,0);
	
	beak_speed = lerp(beak_speed, (-beak_position)/4, delta*8);
	beak_position += beak_speed*60*delta;
	beak.rotation_degrees = beak_position;
	beak_speed += (beak.global_rotation_degrees - beak_old_global)*delta*2;
	
	feathers_speed = lerp(feathers_speed,(-feathers_position)/6, delta*4);
	feathers_position += feathers_speed*60*delta;
	feathers.rotation_degrees = feathers_position;
	feathers_speed += (feathers.global_rotation_degrees - feathers_old_global)*delta*1.5;
	
	body_speed = lerp(body_speed, (-body_position)/2, delta*7);
	body_position += body_speed*60*delta;
	body.rotation_degrees = body_position;
	
	wing_speed = lerp(wing_speed, (-wing_position)/4, delta * 10)#	wing_position += wing_speed;
	wing_position += wing_speed*60*delta;
	wing.rotation_degrees = wing_position;
	
	pass
