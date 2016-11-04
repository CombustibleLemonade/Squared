extends Node

onready var global = get_node("/root/global")
onready var options = get_node("/root/options")

var master_volume = 0.6 setget set_master_volume

func set_master_volume(v):
	master_volume = v
	
	options.options["audio_master"] = v
	apply_volume()
	options.save_options()

func apply_volume():
	global.sounds.set_default_volume(options.options["audio_master"])
