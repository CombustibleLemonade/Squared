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

func press():
	emit_signal("pressed")

func set_value(var value_arg):
	value = clamp(value_arg, min_val, max_val)
	
	if has_node("value"):
		get_node("value").set_text(str(value))

func focus(var inc_dec = null):
	emit_signal("focus", self)
	pass

func increment():
	set_value(value+1)

func decrement():
	set_value(value-1)

func set_text(var text_arg):
	text = text_arg
	if has_node("label"):
		get_node("label").set_text(text_arg)

func get_text():
	return text
