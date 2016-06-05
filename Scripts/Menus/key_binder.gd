tool
extends "menu_entry.gd"

signal pressed
signal key_set
signal focus(entry)

export(String) var text setget set_text
export(String) var key setget set_key
export(String) var is_editable = true

var key_event = null
var is_being_edited = false

func _input_event(event):
	if !is_being_edited:
		get_node("/root/main").set_menu_lock(false)
	
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
	
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		press()
	
	if is_being_edited and event.type == InputEvent.KEY and event.is_pressed():
		if event.is_action("ui_cancel"):
			set_key_event(key_event)
		else:
			set_key_event(event)
			emit_signal("key_set")
		
		is_being_edited = false

func set_text(t):
	text = t
	if has_node("label"):
		get_node("label").set_text(t)

func set_key(k):
	key = k
	if has_node("key"):
		get_node("key").set_text(k)

func set_key_event(ev):
	set_key(OS.get_scancode_string(ev.scancode))
	key_event = ev

# Check if the keybinding is set yet
func is_key_valid():
	return key_event != null

func press():
	emit_signal("pressed")
	if is_editable:
		is_being_edited = true
		set_key("Press a key")
		get_node("/root/main").set_menu_lock(true)
