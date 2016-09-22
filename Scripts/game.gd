extends Node2D

var drop_time = 4

var config setget parse_object
var died = false setget set_died, get_died # Have we died yet?

var fields = [] # Amount of fields in game
var setup

func _ready():
	set_layout()

# Set up all fields with the right configuration and settings
func set_setups(s):
	setup = s
	var player_count = s.config.player_count
	
	for i in range(player_count):
		add_field(i)
	
	parse_object(setup)

# Adds a field with a certain field config
func add_field(index):
	var field = preload("res://Scenes/Game/field.scn").instance()
	
	add_child(field)
	fields.push_back(field)

func parse_object(o):
	var dict = inst2dict(o)
	
	var keys = dict.keys()
	
	for k in keys:
		if typeof(dict[k]) == typeof([]):
			for i in range(fields.size()):
				if k in fields[i]:
					fields[i].set(k, dict[k][i])
		else:
			if k in self:
				set(k, dict[k])

# TODO: Sets the layout of the fields
# Doesn't yet work for 3+ players
func set_layout():
	if fields.size() == 1:
		fields[0].fit_in_rect(Rect2(Vector2(), OS.get_window_size()))
	if fields.size() == 2:
		var size = Vector2(OS.get_window_size().x / 2, OS.get_window_size().y)
		var half_pos = Vector2(OS.get_window_size().x / 2, 0)
		fields[0].fit_in_rect(Rect2(Vector2(), size))
		fields[1].fit_in_rect(Rect2(half_pos, size))

# Start playing again
func activate():
	for f in fields:
		f.activate()

# Set if we're dead. Does nothing
func set_died(died_field):
	died_field.died = true
	
	var all_dead = true
	
	for f in fields:
		all_dead = all_dead && f.died
	
	if all_dead:
		deactivate()

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	set_pause_mode(1)
	for f in fields:
		f.record.pause()
	get_node("/root/main").pause()


# Returns true if we're dead
func get_died():
	if fields.size() == 0:
		return true
	
	var d = false
	for f in fields:
		d = d || f.died
	
	return d

# Updates the score for a field
func update_score(field, score):
	if fields.size() == 1:
		field.set_score(score)
	else:
		for f in fields:
			if f != field:
				f.set_score(100 - score)
				
				if 100 - score < 0:
					field.die()
					f.die()
