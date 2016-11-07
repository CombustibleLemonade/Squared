extends Node2D

var time_left = 0

onready var game = get_node("game")

var drop_time setget set_drop_time
var record
var config

var actions
var replay_speed = 1

# Sets the drop time
func set_drop_time(d):
	drop_time = d
	get_node("game").drop_time = d

# Sets the setup
func set_setups(setup):
	get_node("game").set_setups(setup)

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
	pass
	#for f in get_node("game").fields:
	#	f.random_seed = record.random_seed
	#get_node("game").next_rand_seed = record.random_seed

func _ready():
	set_process_input(true)
	
	for f in get_node("game").fields:
		f.is_replay = true
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
	time_left += actions[0][2]
	print(actions)

func pause():
	game.deactivate()

func set_died(n):
	pause()

func _process(delta):
	# TODO: rewrite this to work with fields
	time_left -= delta * 1000 * replay_speed
	
	if time_left + (1 - replay_speed) * delta > 0:
		get_node("game").progress_time( replay_speed * delta )
	
	if time_left <= 0 and not actions.size() == 0:
		var action = actions[0][0]
		
		var f = actions[0][1] # Active field
		
		if action == "drop":
			game.fields[f].get_node("grid/dropindicator")._on_Timer_timeout()
		else:
			game.fields[f].input(actions[0][0])
		
		if not actions.size() == 1:
			time_left += actions[1][2] - actions[0][2]
		
		actions.remove(0)

func update_score(node, score):
	node.set_score(score)
