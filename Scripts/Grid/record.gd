extends Node

var score

var drop_time
var has_undo
var config

var start_time
var actions = []
var blocks = []

# Will play the replay
# TODO
func start_replay():
	pass

func _init():
	start_time = OS.get_ticks_msec()

func save_event(ev):
	actions.push_back([ev, OS.get_ticks_msec() - start_time])
