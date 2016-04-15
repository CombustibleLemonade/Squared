extends Node

var schemes = []
var bindings = {}

func _init():
	add_default_scheme()

# Adds the default control scheme
func add_default_scheme():
	add_control_scheme("default 1")
	add_binding("default 1", "next", key_event(KEY_CONTROL))
	add_binding("default 1", "up", key_event(KEY_UP))
	add_binding("default 1", "down", key_event(KEY_DOWN))
	add_binding("default 1", "left", key_event(KEY_LEFT))
	add_binding("default 1", "right", key_event(KEY_RIGHT))
	
	add_control_scheme("default 2")
	add_binding("default 2", "next", key_event(KEY_SHIFT))
	add_binding("default 2", "up", key_event(KEY_W))
	add_binding("default 2", "down", key_event(KEY_S))
	add_binding("default 2", "left", key_event(KEY_A))
	add_binding("default 2", "right", key_event(KEY_D))

# Returns a key event according to a scancode
func key_event(scancode):
	var event = InputEvent()
	event.type = InputEvent.KEY
	event.device = 0
	event.scancode = scancode
	
	return event

# Parse input
func parse_input(scheme, a):
	var actions = []
	
	for i in ["next", "up", "down", "left", "right"]:
		if a.is_action(scheme + "/" + i) and not a.is_echo() and a.is_pressed():
			actions.push_back(i)
	
	return actions

# Adds a control scheme
func add_control_scheme(name):
	if name.find("/") != -1:
		# TODO make dialog thing appear
		print("player names can't contain forward slashes (/).")
		return
	
	InputMap.add_action(name + "/next")
	InputMap.add_action(name + "/up")
	InputMap.add_action(name + "/down")
	InputMap.add_action(name + "/left")
	InputMap.add_action(name + "/right")
	
	schemes.push_back(name)
	bindings[name] = []

# Adds a binding for the player
func add_binding(scheme, type, control):
	InputMap.action_add_event(scheme + "/" + type, control)
	bindings[scheme].push_back(control)

# TODO
func get_icon(scheme, type):
	pass
