extends Node2D

class_name text_effect

enum types {TEST, LETTER, PUNCTUATION, DELETING, PASTE, BULK_DELETE, PASSIVE}

export (String) var text
export (Font) var font
export (float) var lifetime
export (types) var type
export (PackedScene) var explosion

var l_scale = -5.0
var l_scale_speed = 300.0

var d_speed = Vector2(0,0)
var d_distance = 5.0
var flash_color = Color()
var color_archive = [Color("ff0080"),Color("ff8000"),Color("80ff00"),Color("00ff80"),Color("0080ff"),Color("8000ff")]
var s_color = Color("ff0080")
var e_color := Color("e0e0e0")

var framecount = 0

func _ready():
	s_color = color_archive[randi()%color_archive.size()]
	
	for i in [$mover/Label, $mover/Label2]:
		i.text = text
		i.rect_size = Vector2()
		i.rect_position = -i.rect_size
	
	$mover/Label.rect_position += Vector2(
		ProjectSettings.get_setting("textreme/editor/shadow_offset_x"),
		ProjectSettings.get_setting("textreme/editor/shadow_offset_y")
	)
	
	e_color = ProjectSettings.get_setting("textreme/editor/font_color")
	$mover/Label2.set("custom_colors/font_color", e_color)
	$mover/Label.set("custom_colors/font_color",
			ProjectSettings.get_setting("textreme/editor/font_shadow_color"))
	
	$mover/Label.rect_pivot_offset = $mover/Label.rect_size * Vector2(0.5, 1)
	$mover/Label2.rect_pivot_offset = $mover/Label2.rect_size * Vector2(0.5, 1)
	
	$"red square".self_modulate = (
		ProjectSettings.get_setting("textreme/editor/font_background_color")
		)
	$"red square".rect_size = $mover/Label.rect_size
	$"red square".rect_position = - $"red square".rect_size
	
	if type == types.DELETING:
		delte_setup()
	else:
		letter_setup()
	
	if text == ".":
		framecount = 1


func _physics_process(delta):
	if type == types.DELETING:
		delete_animation(delta)
	else:
		letter_animation(delta)
	
	
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func letter_setup():
	var id = str(randi()%9)
	get_node("pop"+ id).volume_db = -5
	get_node("pop"+ id).playing = true
	lifetime = 0.2 + rand_range(0.0, 0.05)


func letter_animation(delta):
	flash_color = lerp(e_color,s_color,(lifetime-0.1)*10)
	$mover/Label2.self_modulate = flash_color
	
	$mover/Label.rect_scale = Vector2(pow(1.2,l_scale), pow(1.2,-l_scale))
	$mover/Label2.rect_scale = Vector2(pow(1.2,l_scale), pow(1.2,-l_scale))
	l_scale_speed = lerp(l_scale_speed, (-l_scale)*30, delta*30)
	l_scale += l_scale_speed*delta
	$mover/Label.rect_scale = Vector2(pow(1.2,l_scale), pow(1.2,-l_scale))
	$mover/Label2.rect_scale = Vector2(pow(1.2,l_scale), pow(1.2,-l_scale))

func delte_setup():
	var id = str(randi()%9)
	get_node("unpop"+ id).volume_db = -5
	get_node("unpop"+ id).playing = true
	d_speed = Vector2(rand_range(-1500,-1200), rand_range(-800,-500))
	lifetime = 5.0 + rand_range(0.0, 10.0)
	$"red square".visible = false;
	$mover/Label.set("custom_colors/font_color",
		ProjectSettings.get_setting("textreme/editor/font_falling_shadow_color"))

func delete_animation(delta):
	$mover.position += d_speed*delta
	d_speed.y += 4000*delta
	d_distance += 100*delta
	$mover.rotate(-d_speed.length()*delta*0.01)
	$mover/Label2.rect_global_position = $mover/Label.rect_global_position + Vector2(0, -d_distance)

func do_an_explosion():
	var effect = explosion.instance()
	effect.global_position = $"red square".global_position
	get_parent().add_child(effect)
