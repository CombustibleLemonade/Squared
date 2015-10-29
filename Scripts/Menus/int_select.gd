tool
extends HBoxContainer

export(int) var value setget set_value
export(String) var text setget set_text

var global

func set_value(var value_arg):
	var node = get_node("value")
	if not node == null:
		node.set_text(str(value_arg))
	value = value_arg
	pass

func set_text(var text_arg):
	text = text_arg
	get_node("label").set_text(text_arg)
	pass

func get_text():
	return text