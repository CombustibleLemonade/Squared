extends Node

var is_fullscreen setget set_fullscreen, get_fullscreen

func set_fullscreen(f):
	OS.set_window_fullscreen(true)

func get_fullscreen():
	return OS.is_window_fullscreen()
