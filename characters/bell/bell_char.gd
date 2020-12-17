extends Node2D

var char_disabled = false

func set_is_disabled(new_value : bool):
	$character_hider.set_is_disabled(new_value)

#USE ring() FUNCTION TO TRIGGER ANIMATION 

func ring(is_damped := false):
	if char_disabled:
		return
	$ding.play()
	$ding.volume_db = ding_damped_value if is_damped else ding_default_value
	if rope_speed >= 0 :
		rope_speed += 10;
	else:
		rope_speed -= 10;


#node reference declaration
onready var rope = $rope;
onready var bell = $rope/bell;
onready var tongue = $rope/bell/tongue;
onready var eyes = $rope/bell/eyes;
onready var pupils = $rope/bell/eyes/pupils;

#animation variable declaration
var rope_position = 0.0;
var rope_speed = 0.0;

var tongue_position = 0.0;
var tongue_speed = 0.0;

var pupil_position = Vector2(0,0);
var pupil_speed = Vector2(0,0);

onready var ding_default_value : float = $ding.volume_db
const ding_damped_value : float = -10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pupil_old_global = pupils.global_position;
	
	rope_speed = lerp(rope_speed, -rope_position/1.5, delta*3);
	rope_position += rope_speed*60*delta;
	rope.rotation_degrees = rope_position;
	
	tongue_speed = lerp(tongue_speed, (rope_position-tongue_position)/2, delta*3);
	tongue_position += tongue_speed*60*delta;
	
	var tonguelimit = 30;
	if tongue_position >= tonguelimit:
		tongue_position = tonguelimit;
		tongue_speed *= -1;
	
	if tongue_position <= -tonguelimit:
		tongue_position = -tonguelimit;
		tongue_speed *= -1;
	
	tongue.rotation_degrees = tongue_position
	
	pupil_speed += (pupils.global_position - pupil_old_global)*delta*6 + Vector2(0, 0.15);
	pupil_speed = lerp(pupil_speed, (Vector2(0,0) - pupil_position)/2, delta*3);
	pupil_position += pupil_speed;
	
	if pupil_position.length() > 10:
		pupil_position = pupil_position.normalized() * 10;
		pupil_speed = Vector2(0,0);
	
	pupils.position = pupil_position + Vector2(0,126);
	
	if Input.is_action_just_pressed("q"):
		ring()
		#trigger this on newline, the poke event is for testing only
		pass


