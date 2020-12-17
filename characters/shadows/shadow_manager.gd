extends Node2D

export (PackedScene) var shadow_3d

onready var managee = get_parent()


func _ready():
	_apply_shadows(managee.get_children())


func _apply_shadows(nodes : Array):
	for node in nodes:
		_apply_shadows(node.get_children())
		if node is Sprite:
			var shadow = shadow_3d.instance()
			node.add_child(shadow)
