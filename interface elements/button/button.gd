extends Control
 
signal clicked;

export var text = "a button"
export var up_color = Color(1,1,1);
export var down_color = Color(0,0,0);
export var release_color = Color(1,0,0)


export var vertical_travel = 20;
export var release_pop = 5;
export var button_lerp_down = 20;
export var button_lerp_up = 10;
export var button_base_scale = 0.1;
export var down_squish = 0.5;
export var up_stretch = 1.5;
export var release_fade = 1.0;

var jiggle_scale = 1.0;
var jiggle_scale_speed = 0.0;
var fade = 0.0;
var hover = false;
onready var button_top = $base/top
onready var button_base = $base
onready var top_origin = button_top.rect_position;

var was_down = false;


func _ready():
	$base/top/Label1.text = text
	$base/top/Label2.text = text
	button_top.rect_pivot_offset = button_top.rect_size/2
	pass


func _physics_process(delta):
	#print(top_origin)
	if Input.is_action_just_released("click") && hover:
		trigger_action()
	
	if hover && Input.is_action_pressed("click"):
		#button depressed
		jiggle_scale_speed = lerp(jiggle_scale_speed, (down_squish - jiggle_scale)*20, delta*40)
		jiggle_scale += jiggle_scale_speed*delta;
		button_top.self_modulate = down_color
		button_top.rect_position = lerp(button_top.rect_position, top_origin + Vector2(0, vertical_travel), delta*button_lerp_down)
		if !was_down:
			was_down = true;
			$upclick.play()
	else:
		#button idle, process animations after triggering action
		#process animations after recovering from depression
		jiggle_scale_speed = lerp(jiggle_scale_speed, (1-jiggle_scale)*40, delta*20)
		jiggle_scale += jiggle_scale_speed * delta;
		fade = max(fade-delta, 0)
		button_top.self_modulate= lerp(up_color, release_color, fade/release_fade)
		button_top.rect_position = lerp(button_top.rect_position, top_origin, delta * button_lerp_up)
		was_down = false;
	
	button_top.rect_scale = Vector2(pow(1.3, 1 - jiggle_scale), pow(1.3, jiggle_scale - 1)) * button_base_scale
	#button_top.rect_position += (button_top.rect_scale-Vector2(1,1))*button_top.rect_size


func _on_mouse_entered():
	hover = true;

func _on_mouse_exited():
	hover = false;

func trigger_action():
	#activate buttons function
	button_top.rect_position = top_origin + Vector2(0, -release_pop)
	jiggle_scale_speed = up_stretch*50;
	fade = release_fade
	$downclick.play();
	emit_signal("clicked")
