tool
extends "menu_entry.gd"

export(String) var text = "" setget change_text
export(bool) var is_on setget change_on

signal toggled(is_on)
signal focus(entry)

func _input_event(event):
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
	
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()

func _ready():
	get_node("label").set_text(text)
	get_node("CenterContainer/Tile").target_cell = null
	get_node("CenterContainer/Tile").set_process(true)
	
	set(true)

func change_text(newvalue):
	text = newvalue
	if has_node("label"):
		get_node("label").set_text(text)

func change_on(newvalue):
	if not is_on == newvalue:
		toggle()

func toggle():
	if is_on:
		get_node("CenterContainer/Tile").target_rotation = PI/2
		get_node("CenterContainer/Tile").set_color("red")
		get_node("CenterContainer/Tile/sprite").set_texture(load("res://Sprites/Tickbox/cross.png"))
	else:
		get_node("CenterContainer/Tile").target_rotation = 0
		get_node("CenterContainer/Tile").set_color("green")
		get_node("CenterContainer/Tile/sprite").set_texture(load("res://Sprites/Tickbox/tick.png"))
	is_on = !is_on
	emit_signal("toggled", is_on)

func press():
	toggle()

func get_text():
	return text

# Sets the state without throwing a signal or slidyness
func set(state):
	if state:
		get_node("CenterContainer/Tile").set_rot(0)
		get_node("CenterContainer/Tile").set_color("green")
		get_node("CenterContainer/Tile/sprite").set_texture(load("res://Sprites/Tickbox/tick.png"))
	else:
		get_node("CenterContainer/Tile").set_rot(PI/2)
		get_node("CenterContainer/Tile").set_color("red")
		get_node("CenterContainer/Tile/sprite").set_texture(load("res://Sprites/Tickbox/cross.png"))
	
	get_node("CenterContainer/Tile").set_rot(get_node("CenterContainer/Tile").target_rotation)
	is_on = state
