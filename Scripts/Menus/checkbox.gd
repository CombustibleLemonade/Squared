tool
extends HBoxContainer

export(String) var text = "" setget change_text
export(bool) var is_on setget change_on

signal toggled(is_on)

func _ready():
	get_node("label").set_text(text)
	get_node("CenterContainer/Tile").target_cell = null
	pass

func change_text(newvalue):
	text = newvalue
	if not get_node("label") == null:
		get_node("label").set_text(text)
	pass

func change_on(newvalue):
	if not is_on == newvalue:
		toggle()
	pass

func toggle():
	if is_on:
		get_node("CenterContainer/Tile").target_rotation = 0
		get_node("CenterContainer/Tile").set_color("red")
	else:
		get_node("CenterContainer/Tile").target_rotation = PI/2
		get_node("CenterContainer/Tile").set_color("green")
	is_on = !is_on
	emit_signal("toggled", is_on)
	pass

func get_text():
	return text