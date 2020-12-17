extends Node2D

var detail = 5
var sprites = []

var texture
export (NodePath) var root

onready var last_position = position

func _ready():
	texture = get_parent().texture
	
	for i in range(detail):
		var sprite = Sprite.new()
		sprite.texture = texture
		sprite.modulate = Color(0, 0, 0)
		sprites.append(sprite)
#		sprite.z_as_relative = true
#		sprite.z_index = -i
		add_child(sprite)
	
	_position_children()


func _process(delta):
	_position_children()
	if position != last_position:
		_position_children()
	last_position = position


func _position_children():
	var resolution := get_viewport().get_visible_rect().size
	var half_x = resolution.x / 2.0
	for i in len(sprites):
		sprites[i].global_position.y = global_position.y + i + 1
		sprites[i].global_position.x = global_position.x + ((i + 1) * ((global_position.x-half_x)/half_x)) * -1
#		sprites[i].global_position.y = global_position.y + (depth * (i+1) * 3 ) / global_scale.y
#		sprites[i].global_position.x = global_position.x + (depth * (((global_position.x - 1080) * -1) / 100) * (i+1)) / global_scale.x
