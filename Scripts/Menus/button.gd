extends "menu_entry.gd"

onready var global = get_node("/root/global")

signal focus(entry)

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed and event.button_index == BUTTON_LEFT:
		press()
	
	if event.type == InputEvent.MOUSE_MOTION:
		focus()

func focus():
	emit_signal("focus", self)

func play_click_sound():
	if get_name() == "back":
		global.sounds.play("back")
	else:
		global.sounds.play("click")
