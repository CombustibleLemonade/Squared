extends Node2D

# Node shortcuts
var global
var selector
var grid

export(int) var width # Amount of columns 	-- x
export(int) var height # Amount of rows 	-- y

var died = false # Have we died yet?

var mutation_set # Set of square color-shapes
var configuration setget set_config
var drop_time = 4

var record = preload("res://Scripts/Grid/record.gd").new()

func _ready():
	# Initialization
	global = get_node("/root/global")
	selector = get_node("grid/selector")
	grid = get_node("grid")
	
	set_process(true)
	
	get_node("incoming").set_pos(Vector2(width*64 + 64, 8*32))
	get_node("Score").set_margin(MARGIN_LEFT, width*32+200)
	get_node("Score").set_margin(MARGIN_RIGHT, width*32+100)
	grid.set_focus(0)
	grid.get_node("selector").max_y = height - 1
	grid.get_node("selector").set_active(true)
	
	configuration = preload("global.gd").Configuration.new()
	configuration.width = width
	configuration.height = height

func _process(delta):
	var scores = ""
	var i = 0
	while i < grid.groups.size():
		if grid.groups[i].member_count > 0:
			scores += str(grid.groups[i].member_count) + "\n"
			i += 1
		else:
			grid.groups.remove(i)
	
	get_node("Score/Label").set_text(str(compute_score()))

# Sets the configuration (with, height, etc.) of the game
func set_config(c):
	configuration = c
	record.config = c
	
	width = c.width
	height = c.height
	
	get_node("grid/selector").set_size( Vector2(width * 64, 64) )

# Computes the score and triggers game over
func die():
	var score = compute_score()
	
	record.score = score
	record.drop_time = drop_time
	record.has_undo = false
	
	save_score(inst2dict(record), configuration)
	
	died = true
	deactivate()

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	get_tree().set_pause(true)
	set_pause_mode(1)
	get_parent().pause()

# Computes the score
func compute_score():
	var score = 0
	for i in get_node("grid").groups:
		score += i.member_count*(i.member_count+1)/2
	return score

# Saves the score to the filesystem
func save_score(s, c):
	var data = global.load_file("user://savegame.save")
	var key = str(inst2dict(c))
	
	if data.has(key):
		data[key].push_back(s)
	else:
		data[key] = [s]
	
	global.save_file("user://savegame.save", data)
