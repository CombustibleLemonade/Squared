tool

extends HBoxContainer

signal pressed
signal focus(entry)

export(String) var text setget set_text
export(String) var key setget set_key

func _input_event(event):
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
	
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()

func set_text(t):
	text = t
	if has_node("label"):
		get_node("label").set_text(t)

func set_key(k):
	key = k
	if has_node("key"):
		get_node("key").set_text(k)

func press():
	emit_signal("pressed")
