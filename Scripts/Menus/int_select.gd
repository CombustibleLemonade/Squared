tool
extends HBoxContainer

export var min_val = 1
export var max_val = 10

export(int) var value setget set_value
export(String) var text setget set_text

signal focus(entry)
signal pressed

var global

func _input_event(event):
	if event.type == InputEvent.MOUSE_MOTION:
		focus()
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		emit_signal("pressed")
	
	if event.type == InputEvent.KEY:
		if event.is_action_pressed("ui_left"):
			decrement()
		if event.is_action_pressed("ui_right"):
			increment()

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

func focus(var inc_dec = null):
	emit_signal("focus", self)
	pass

func increment():
	set_value(value+1)
	pass

func decrement():
	set_value(value-1)
	pass

func set_text(var text_arg):
	text = text_arg
	if not get_node("label") == null:
		get_node("label").set_text(text_arg)
	pass

func get_text():
	return text
