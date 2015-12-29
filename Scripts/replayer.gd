extends Node2D

var time_left = 0

var drop_time setget set_drop_time
var record

var actions

# Sets the drop time
func set_drop_time(d):
	drop_time = d
	get_node("game").drop_time = d

# Sets the config
func set_config(c):
	get_node("game").set_config(c)

# Fixes all actions not being pressed
func fix_actions_pressed(actions):
	var pressedkeys = {}
	
	for i in actions:
		if pressedkeys.has(i[0].scancode):
			pressedkeys.erase(i[0].scancode)
			i[0].pressed = false
		else:
			pressedkeys[i[0].scancode] = i[0].scancode
			i[0].pressed = true
	
	return actions

func _enter_tree():
	get_node("game").random_seed = record.random_seed
	get_node("game").next_rand_seed = record.random_seed

func _ready():
	get_node("game").is_replay = true
	actions = record.actions
	actions = fix_actions_pressed(actions)
	start()

func _input(event):
	if event.is_action("ui_cancel"):
		pause()

func start():
	set_process(true)
	time_left += actions[0][1]

func pause():
	get_node("/root/main").pause()

func _process(delta):
	time_left -= delta * 1000
	
	if time_left <= 0 and not actions.size() == 0:
		get_node("game").input(actions[0][0])
		
		if not actions.size() == 1:
			time_left += actions[1][1] - actions[0][1]
		
		actions.remove(0)
	
	if actions.size() == 0:

