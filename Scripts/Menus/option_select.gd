extends "menu_entry.gd"

export(Array) var possible_values setget set_possible_values
export(int) var value = 0 setget set_value, get_value

signal focus(entry)
signal change # Emitted when the value changes

var global

func _init():
	if possible_values == null or possible_values.size() == 0:
		possible_values = ["option"]
	set_value(value)

func _ready():
	global = get_node("/root/global")
	set_value(value)

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

# Sets the possible values
func set_possible_values(var value_arg):
	possible_values = value_arg

# Sets the value of the selector
func set_value(var value_arg):
	value = clamp(value_arg, 0, possible_values.size()-1)
	
	if has_node("value"):
		get_node("value").set_text(str(possible_values[value]))
	
	emit_signal("change")

# Returns the int value of the selector
func get_value():
	return value

# Returns the text value of the selector
func get_value_string():
	return possible_values[value]

func focus(var inc_dec = null):
	emit_signal("focus", self)

func increment():
	set_value(value+1)

func decrement():
	set_value(value-1)
