extends Node2D

var time_left = 0

var drop_time setget set_drop_time
var record

var actions
var replay_speed = 1

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
	
	var ret = [] # Use a new array (since arrays are passed by reference)
	
	for i in actions:
		if typeof(i[0]) == typeof(""):
			ret.push_back(i)
		elif not i[0].is_action("ui_cancel"):
			if i[0].type == 1 and pressedkeys.has(i[0].scancode):
				pressedkeys.erase(i[0].scancode)
				i[0].pressed = false
			elif i[0].type == 1:
				pressedkeys[i[0].scancode] = i[0].scancode
				i[0].pressed = true
			ret.push_back(i)
	
	return ret

func _enter_tree():
	get_node("game").random_seed = record.random_seed
	get_node("game").next_rand_seed = record.random_seed

func _ready():
	set_process_input(true)
	
	get_node("game").is_replay = true
	actions = fix_actions_pressed(record.actions)
	
	set_global_pos(OS.get_window_size()/2)
	
	start()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause()
	
	# TODO fix timer speed
	if event.is_action_pressed("replay_speedup"):
		replay_speed *= 1.5
	if event.is_action_pressed("replay_slowdown"):
		replay_speed /= 1.5

func start():
	set_process(true)
	time_left += actions[0][1]

func pause():
	get_node("/root/main").pause()

func _process(delta):
	time_left -= delta * 1000 * replay_speed
	
	if time_left + (1 - replay_speed) * delta > 0:
		get_node("game/grid/dropindicator").time_left -=  replay_speed * delta
	
	if time_left <= 0 and not actions.size() == 0:
		var action = actions[0][0]
		if typeof(action) == typeof(""):
			get_node("game/grid/dropindicator")._on_Timer_timeout()
		else:
			get_node("game").input(actions[0][0])
		
		if not actions.size() == 1:
			time_left += actions[1][1] - actions[0][1]
		
		actions.remove(0)
	
	if actions.size() == 0:

