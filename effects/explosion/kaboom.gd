extends Node2D

var start_scale = 0.3
onready var default_value : float = $AudioStreamPlayer.volume_db
const damped_volume := -10.0

func set_is_damped(value : bool):
	$AudioStreamPlayer.volume_db = damped_volume if value else default_value

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.rotation = rand_range(0,2*PI)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite.frame == 16:
		$AnimatedSprite.visible = false
	
	if !$AudioStreamPlayer.playing:
		queue_free()
	pass
