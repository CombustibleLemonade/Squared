tool
extends HBoxContainer

export(String) var text = "" setget change_text
export(bool) var is_on setget change_on

signal toggled(is_on)
signal focus(entry)

func _input_event(event):
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
	
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()
	pass

func _ready():
	get_node("label").set_text(text)
	get_node("CenterContainer/Tile").target_cell = null
	get_node("CenterContainer/Tile").set_process(true)
	pass

func change_text(newvalue):
	text = newvalue
	if has_node("label"):
		get_node("label").set_text(text)
	pass

func change_on(newvalue):
	if not is_on == newvalue:
		toggle()
	pass

func toggle():
	if is_on:
		get_node("CenterContainer/Tile").target_rotation = PI/2
		get_node("CenterContainer/Tile").set_color("red")
		get_node("CenterContainer/Tile/Sprite").set_texture(load("res://Sprites/Tickbox/cross.png"))
	else:
		get_node("CenterContainer/Tile").target_rotation = 0
		get_node("CenterContainer/Tile").set_color("green")
		get_node("CenterContainer/Tile/Sprite").set_texture(load("res://Sprites/Tickbox/tick.png"))
	is_on = !is_on
	emit_signal("toggled", is_on)
	pass

func press():
	toggle()
	pass

func get_text():
	return text
