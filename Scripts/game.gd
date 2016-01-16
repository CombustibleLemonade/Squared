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
var drop_time = 4 # Amount of time between block drops

var random_seed # Seed used bu this game
var next_rand_seed # Intermediate seed

var record = preload("res://Scripts/Grid/record.gd").new()

var is_replay = false

func _init():
	random_seed = randi()
	next_rand_seed = random_seed

func _ready():
	# Initialization
	global = get_node("/root/global")
	selector = get_node("grid/selector")
	grid = get_node("grid")
	
	set_process(true)
	set_process_input(true)
	
	get_node("incoming").set_pos(Vector2(width*64 + 64, 8*32))
	get_node("score").set_margin(MARGIN_LEFT, width*32+200)
	get_node("score").set_margin(MARGIN_RIGHT, width*32+100)
	grid.set_focus(0)
	grid.get_node("selector").max_y = height - 1
	grid.get_node("selector").set_active(true)
	
	configuration = preload("global.gd").Configuration.new()
	configuration.width = width
	configuration.height = height
	
	for i in range(width):
		var number = Label.new()
		number.set_text(str(i))
		number.set_custom_minimum_size(Vector2(64, 0))
		number.set_align(Label.ALIGN_CENTER)
		get_node("numbering").add_child(number)

func _process(delta):
	var scores = ""
	var i = 0
	while i < grid.groups.size():
		if grid.groups[i].member_count > 0:
			scores += str(grid.groups[i].member_count) + "\n"
			i += 1
		else:
			grid.groups.remove(i)
	
	get_node("score/Label").set_text(str(compute_score()))
	
	fit_in_rect(Rect2(Vector2(), OS.get_window_size()))

func _input(e):
	if not is_replay:
		input(e)

func input(e):
	if not e.is_action("Next"):
		record.save_event(e)
	get_node("grid").input(e)
	get_node("grid/selector").input(e)

# Sets the configuration (with, height, etc.) of the game
func set_config(c):
	configuration = c
	record.config = inst2dict(c)
	
	width = c.width
	height = c.height
	
	get_node("grid/selector").set_size( Vector2(width * 64, 64) )

# Computes the score and triggers game over
func die():
	var date = OS.get_date()
	var time = OS.get_time()
	
	var score = compute_score()
	
	record.score = score
	record.drop_time = drop_time
	record.has_undo = false
	record.random_seed = random_seed
	record.date = [date, time]
	
	if not is_replay:
		global.save_score(inst2dict(record), configuration)
	
	died = true
	deactivate()

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	set_pause_mode(1)
	record.pause()
	get_parent().pause()

# Gets called when the game resumes
func activate():
	if not is_replay:
		record.resume()
# Computes the score
func compute_score():
	var score = 0
	for i in get_node("grid").groups:
		score += i.member_count*(i.member_count+1)/2
	return score

# Returns a random integer
func next_int():
	var next = rand_seed(next_rand_seed)
	next_rand_seed = next[0]
	return next[0]

# Fits the game in a certain rectangle. Measured in pixels
func fit_in_rect(rect):
	var scale = rect.size.y/OS.get_window_size().y
	set_scale(Vector2(scale, scale))
	
	set_global_pos(OS.get_window_size()/2)
