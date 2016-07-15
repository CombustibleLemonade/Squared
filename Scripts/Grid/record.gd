extends Node

var version = "alpha 0.1"

var date
var score

var drop_time
var has_undo
var config

var start_time
var pause_time
var actions = []
var blocks = []

var random_seed

func _init():
	start_time = OS.get_ticks_msec()

func save_event(ev):
	actions.push_back([ev, OS.get_ticks_msec() - start_time])

func pause():
	pause_time = OS.get_ticks_msec()

func resume():
	var delta = OS.get_ticks_msec() - pause_time
	start_time += delta
