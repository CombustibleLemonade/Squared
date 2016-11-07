extends Node2D

var drop_time = 4

var config setget parse_object
var died = false setget set_died, get_died # Have we died yet?

var fields = [] # Amount of fields in game
var setup
var is_replay

var random_seed # Seed used by this game
var next_rand_seed # Intermediate seed
var record = preload("res://Scripts/Grid/record.gd").new()

func _ready():
	set_layout()

# Set up all fields with the right configuration and settings
func set_setups(s):
	setup = s
	var player_count = s.config.player_count
	
	if s.random_seed == 0:
		s.random_seed = randi()
	
	random_seed = s.random_seed
	next_rand_seed = s.random_seed
	
	for i in range(player_count):
		add_field(i, s.random_seed)
	
	if s.scheme[0] == "@REPLAY":
		is_replay = true
		for f in fields:
			f.is_replay = true
	
	parse_object(setup)

# Adds a field with a certain field config
func add_field(index, r):
	var field = preload("res://Scenes/Game/field.scn").instance()
	
	add_child(field)
	fields.push_back(field)

# Sets the configuration
# TODO: rename this
func parse_object(o):
	config = o
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
	record.resume()

# Set if we're dead. Does nothing
func set_died(died_field):
	died_field.died = true
	
	var all_dead = true
	
	for f in fields:
		all_dead = all_dead && f.died
	
	if all_dead:
		finish()

# Gets called when the game finishes
func finish():
	deactivate()
	var r = global.inst3dict(record)
	
	if not is_replay:
		get_node("/root/highscores").save_score(r, config)

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	set_pause_mode(1)
	record.pause()
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

# Makes time progress in a replay
func progress_time(delta):
	for f in fields:
		f.get_node("grid/dropindicator").time_left -=  delta

# Returns a random integer
func next_int():
	var next = rand_seed(next_rand_seed)
	next_rand_seed = next[0]
	return next[0]