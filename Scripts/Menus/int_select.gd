tool
extends HBoxContainer

export var min_val = 1
export var max_val = 10

export(int) var value setget set_value
export(String) var text setget set_text

var global

func set_value(var value_arg):
	value = value_arg
	
	if not min_val == null and value < min_val:
		value = min_val
	if not max_val == null and value > max_val:
		value = max_val
	
	var node = get_node("value")
	if not node == null:
		node.set_text(str(value))
	pass

func set_text(var text_arg):
	text = text_arg
	get_node("label").set_text(text_arg)
	pass

func get_text():
	return text