extends HBoxContainer

signal pressed
signal focus(entry)

func _ready():
	set_process(true)

func _process(delta):
	if get_node("/root/main").get_active_entry() == self:
		get_node("container/line").grab_focus()
	else:
		get_node("container/line").release_focus()

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()
	
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)

func press():
	emit_signal("pressed")

func get_text():
	return get_node("container/line").get_text()
