extends Control

onready var parent = get_parent()

func set_is_disabled(new_value : bool):
	if parent.char_disabled != new_value:
		_toggle_disable_character()

func _ready():
	$DebugRect.hide()

func _gui_input(event : InputEvent):
	if (event is InputEventMouseButton
			&& event.is_pressed()
			&& !event.is_echo()
			&& event.button_index in [BUTTON_LEFT, BUTTON_RIGHT]):
		_toggle_disable_character()


func _toggle_disable_character():
	parent.char_disabled = !parent.char_disabled
	if parent.char_disabled:
		parent.modulate = Color.from_hsv(0, 0, 0.75)
	else:
		parent.modulate = Color.from_hsv(0, 0, 1)
	_toggle_shadows(!parent.char_disabled, parent.get_children())
	if parent.char_disabled: $off.play()
	else: $on.play()


func _toggle_shadows(on : bool, nodes : Array):
	for i in nodes:
		if i.is_in_group("shadow"):
			i.visible = on
		_toggle_shadows(on, i.get_children())
