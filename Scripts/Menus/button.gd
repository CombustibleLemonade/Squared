extends Label

signal pressed
signal focus(entry)

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()
	
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)

func press():
	emit_signal("pressed")