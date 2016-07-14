extends Node

onready var global = get_node("/root/global")

var path = "user://ControlSchemes/control_schemes.save"

var schemes = []
var bindings = {}
var controls = ["up", "down", "left", "right", "next"]

func _ready():
	var loaded_bindings = global.load_file(path)
	
	if loaded_bindings == null:
		add_default_scheme()
		save_scheme()
	else:
		for i in loaded_bindings.keys():
			add_control_scheme(i)
			
			for j in controls:
				add_binding(i, j, loaded_bindings[i][j])
	
	schemes.sort()


# Adds the default control scheme
func add_default_scheme():
	add_control_scheme("default 1")
	add_binding("default 1", "up", key_event(KEY_UP))
	add_binding("default 1", "down", key_event(KEY_DOWN))
	add_binding("default 1", "left", key_event(KEY_LEFT))
	add_binding("default 1", "right", key_event(KEY_RIGHT))
	add_binding("default 1", "next", key_event(KEY_SPACE))
	
	add_control_scheme("default 2")
	add_binding("default 2", "up", key_event(KEY_W))
	add_binding("default 2", "down", key_event(KEY_S))
	add_binding("default 2", "left", key_event(KEY_A))
	add_binding("default 2", "right", key_event(KEY_D))
	add_binding("default 2", "next", key_event(KEY_SHIFT))

# Returns a key event according to a scancode
func key_event(scancode):
	var event = InputEvent()
	event.type = InputEvent.KEY
	event.device = 0
	event.scancode = scancode
	
	return event

# Parse input
func parse_input(scheme, a):
	if typeof(a) == typeof(""):
		return [a]
	
	var actions = []
	
	for i in controls:
		if a.is_action(scheme + "/" + i) and not a.is_echo() and a.is_pressed():
			actions.push_back(i)
	
	return actions

# Adds a control scheme
func add_control_scheme(name):
	if name.find("/") != -1:
		# TODO make dialog thing appear
		print("player names can't contain forward slashes (/).")
		return
	
	if schemes.find(name) == -1:
		schemes.push_back(name)
		bindings[name] = {}

# Adds a binding for the player, and removes any old one
func add_binding(scheme, type, control):
	if bindings.has(scheme) && bindings[scheme].has(type):
		InputMap.erase_action(scheme + "/" + type)
	
	InputMap.add_action(scheme + "/" + type)
	InputMap.action_add_event(scheme + "/" + type, control)
	bindings[scheme][type] = control

func save_scheme():
	global.save_file(path, bindings)