extends Node2D


var index := 0 #set this when spawning
var text := "UUUUUUUUUUUUUUUUWWUUUUUUUUUUUUUUUU" #set this when spawning
var last_letter_position := Vector2()
var render_offset := 0.0

onready var shadow_node : Label = $scaler/shadow
onready var top_node : Label = $scaler/top

var d_speed := Vector2()
var lifetime := 0.0
var d_distance := 5.0
var rotation_multiplier := 0

func _ready():
	start_sequence()
	yield(get_tree(), "idle_frame")
	
	shadow_node.rect_position.x = -shadow_node.rect_size.x * 0.5
	shadow_node.rect_position += Vector2(
		ProjectSettings.get_setting("textreme/editor/shadow_offset_x"),
		ProjectSettings.get_setting("textreme/editor/shadow_offset_y")
	)
	
	shadow_node.rect_pivot_offset = shadow_node.rect_size / 2.0
	top_node.rect_pivot_offset = top_node.rect_size / 2.0
	
	shadow_node.set("custom_colors/font_color",
		ProjectSettings.get_setting("textreme/editor/font_falling_shadow_color"))
	top_node.set("custom_colors/font_color",
		ProjectSettings.get_setting("textreme/editor/font_color"))
	top_node.rect_position.x = -top_node.rect_size.x * 0.5
	
	var rect_end : Vector2 = top_node.rect_position + top_node.rect_size
	var rect_no_scale := rect_end
	
	global_position = last_letter_position - rect_no_scale
	

func _physics_process(delta):
	process_falling(delta)
	lifetime -= delta
	if lifetime < 0.0:
		queue_free()

func process_falling(delta : float):
	$scaler.position += d_speed * delta
	d_speed.y += 4000 * delta
	d_distance += 100 * delta
	var delta_angle := rad2deg((-d_speed.length() * delta * rotation_multiplier) / 1000.0)
	top_node.rect_rotation += delta_angle
	shadow_node.rect_rotation += delta_angle
	shadow_node.rect_global_position = (top_node.rect_global_position
			+ Vector2(0, -d_distance))


func start_sequence():
	shadow_node.text = text
	top_node.text = text
	
	var soundname := "unpop"+str(randi()%9)
	if index < 10:
		get_node(soundname).play()
	d_speed = Vector2(rand_range(-1500,-1200), rand_range(-800,-500))
	lifetime = 5.0 + rand_range(0.0, 10.0)
	rotation_multiplier = rand_range(1.0, 3.0)
