extends Node2D

var drop_time = 4
var config setget set_config

var died = false setget set_died, get_died # Have we died yet?

var fields = [] # Amount of fields in game

func _ready():
	set_layout()

# Sets the config of the entire game
func set_config(c):
	config = c
	
	for g in fields:
		g.queue_free()
	
	for i in config:
		add_field(i)

# Sets all field to input array
func set_fields(f):
	fields = f

# Adds a field with a certain field config
func add_field(field_config):
	var field = preload("res://Scenes/Game/game.scn").instance()
	field.drop_time = drop_time
	
	field.set_config(field_config)
	add_child(field)
	fields.push_back(field)

# TODO: Sets the layout of the fields
func set_layout():
	if fields.size() == 1:
		fields[0].fit_in_rect(Rect2(Vector2(), OS.get_window_size()))
	if fields.size() == 2:
		var size = Vector2(OS.get_window_size().x / 2, OS.get_window_size().y)
		var half_pos = Vector2(OS.get_window_size().x / 2, 0)
		fields[0].fit_in_rect(Rect2(Vector2(), size))
		fields[1].fit_in_rect(Rect2(half_pos, size))
	
	pass

# Start playing again
func activate():
	for f in fields:
		f.activate()

# Set if we're dead. Does nothing
func set_died(d):
	pass

# Returns true if we're dead
func get_died():
	if fields.size() == 0:
		return true
	
	var d = false
	for f in fields:
		d = d || f.died
	
	return d