extends Node

var players = []

func _ready():
	print("asdf")

# TODO: parse input
func parse_input(a):
	var actions = []
	
	for p in players:
		for i in ["next", "up", "down", "left", "right"]:
			if a.is_action(p + "/" + i):
				actions.push_back([p, i])
	
	return actions

# Adds a control scheme
func add_control_scheme(name):
	if name.contains("/"):
		print("player names can't contain forward slashes (/).")
		return
	
	InputMap.add_action(name + "/next")
	InputMap.add_action(name + "/up")
	InputMap.add_action(name + "/down")
	InputMap.add_action(name + "/left")
	InputMap.add_action(name + "/right")

func add_binding(player, type, control):
	action_add_event(player + "/" + type, control)
