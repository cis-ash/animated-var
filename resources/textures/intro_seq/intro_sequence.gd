extends Node2D
var names = ["Ash_K","Amber Fiddlemouth","Maks Loboda", "Lintilion"]
var speeds = [Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(rand_range(-500,500),rand_range(-500,500))]
onready var labels = [$Control/Name1,$Control/Name2,$Control/Name3,$Control/Name4,$Control/Title]
onready var labels_tops = [$Control/Name1/Name,$Control/Name2/Name,$Control/Name3/Name,$Control/Name4/Name]
var counting = false;
var time = 0.0;
var start_y= 230.0;
var step_y = 70;
var time_step = 0.25;
var title_time = 1.5;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	regular_setup()
	randomize()
	if rand_range(0.0,1.0)>0.99:easter_egg_setup()
	#print(names)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("poke"): 
		#trigger this part of the code on startup after everything is loaded
		counting = true;
		$AudioStreamPlayer.playing = true
	if counting: 
		time += delta;
	
	for i in 4:
		if time > i*time_step:
			speeds[i] = lerp(speeds[i], (Vector2(0,start_y + step_y*i)-labels[i].rect_position)*30, delta*20)
			labels[i].rect_position += speeds[i]*delta
	
	if time > title_time:
		speeds[4] = lerp(speeds[4], (Vector2(0,30)-labels[4].rect_position)*30, delta*10)
		labels[4].rect_position += speeds[4]*delta
	pass

func regular_setup():
	randomize()
	for i in names.size():
		var target = randi()%4
		var temp = names[target]
		names[target] = names[i]
		names[i] = temp
		i += 1;
	
	#labels[0].text = "made by"
	#labels_tops[0].text = "made by"
	labels[0].rect_position = Vector2(1,0).rotated(rand_range(0,2*PI))*1000+Vector2(0,250)
	for i in 4:
		labels[i].text = names[i]
		labels_tops[i].text = names[i]
		labels[i].rect_position = Vector2(1,0).rotated(rand_range(0,2*PI))*1000+Vector2(0,250)
	labels[4].rect_position.y = -300

func easter_egg_setup():
	$Control/Title/Title2.self_modulate = Color("00BFFC")
	$Control/Name1/Name.self_modulate = Color("FD64D3")
	$Control/Name2/Name.self_modulate = Color("ffffff")
	$Control/Name3/Name.self_modulate = Color("FD64D3")
	$Control/Name4/Name.self_modulate = Color("00BFFC")
	#print("GAY")
