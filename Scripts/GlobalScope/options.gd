extends Node

onready var global = get_node("/root/global")
var is_fullscreen setget set_fullscreen, get_fullscreen

# File with all options
var options = {
	"fullscreen" : false, 
	"glow" : 0.45
}

func _ready():
	load_options()

# Makes the window fullscreen or windowed, and saves the setting
func set_fullscreen(is_fullscreen):
	options["fullscreen"] = is_fullscreen
	apply_options()

# Returns if the window is currently fullscreen
func get_fullscreen():
	return OS.is_window_fullscreen()

# Sets the glow to be intensity
func set_glow(intensity):
	options["glow"] = intensity
	apply_options()

# Returns how much glow is currently set
func get_glow():
	return options["glow"]

# Applies the options that are set
func apply_options():
	# Fullscreen
	OS.set_window_fullscreen(options["fullscreen"])
	
	# Glow
	var environment = get_node("/root/main/world_environment").get_environment()
	environment.fx_set_param(Environment.FX_PARAM_GLOW_BLUR_SCALE, options["glow"])
	environment.fx_set_param(Environment.FX_PARAM_GLOW_BLUR_STRENGTH, options["glow"] * 0.4 + 0.8)
	
	save_options()

# Saves the options
func save_options():
	global.save_file("user://Options/options.save", options)

# Loads the options
func load_options():
	var file_options = global.load_file("user://Options/options.save")
	if file_options == null:
		return
	
	for option in options.keys():
		if !file_options.has(option):
			file_options[option] = options[option]
	
	options = file_options
	apply_options()

