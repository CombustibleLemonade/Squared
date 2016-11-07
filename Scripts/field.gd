extends Node2D

# Node shortcuts
var global
var game
var selector
var grid

var scheme = "default 1"
var index = 0 # Index of the field

export(int) var width setget set_width # Amount of columns 	-- x
export(int) var height 				   # Amount of rows 	-- y
export(int) var mutation_count # Amount of different colors

var died = false # Have we died yet?
var drop_time = 4 # Amount of time between block drops

var is_replay = false

func _ready():
	# Initialization
	global = get_node("/root/global")
	game = get_parent()
	selector = get_node("grid/selector")
	grid = get_node("grid")
	
	set_process(true)
	set_process_input(true)
	
	get_node("incoming").set_pos(Vector2(width*64 + 64, 8*32))
	
	grid.set_focus(0)
	grid.get_node("selector").max_y = height - 1
	grid.get_node("selector").set_active(true)
	
	get_node("grid/selector").set_size( Vector2(width * 64, 64) )
	
	for i in range(width):
		var number = Label.new()
		number.set_text(int_to_column(i))
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
	
	get_parent().update_score(self, compute_score())
	
	var window_size = OS.get_window_size()

# Sets the width of the selector
func set_width(w):
	width = w
	if has_node("grid/selector"):
		get_node("grid/selector").set_size( Vector2(width * 64, 64) )

func set_score(score):
	get_node("score/Label").set_text(str(score))

func _input(e):
	if not is_replay and not died:
		input(e)

# Handles input
func input(e):
	var event = get_node("/root/input").parse_input(scheme, e)
	
	for ev in event:
		if ev != "next":
			game.record.save_event(ev, index)
	
	get_node("grid").input(event)
	get_node("grid/selector").input(event)
	
	if typeof(e) != typeof("") and e.is_action_pressed("ui_cancel"):
		compute_score()
		get_parent().deactivate()

# Computes the score and triggers game over
func die():
	var date = OS.get_date()
	var time = OS.get_time()
	
	var score = compute_score()
	
	game.record.score = score
	game.record.config = get_parent().config
	game.record.drop_time = drop_time
	game.record.has_undo = false
	game.record.random_seed = get_parent().random_seed
	game.record.date = [date, time]
	died = true
	
	get_node("grid/dropindicator").set_process(false)
	
	get_parent().set_died(self)

# Computes the score
func compute_score():
	var score = 0
	
	for i in get_node("grid").groups:
		score += i.member_count*(i.member_count+1)/2
	
	return score

# Fits the game in a certain rectangle. Measured in pixels
func fit_in_rect(rect):
	var scale_x = (600/OS.get_window_size().y)/((320 +  width*64)/rect.size.x)
	var scale_y = rect.size.y/OS.get_window_size().y
	
	var scale = min(scale_x, scale_y)
	set_scale(Vector2(scale, scale))
	
	set_global_pos(rect.pos + rect.size/2)

var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Converts an int to a string, with the numbering system of the columns
func int_to_column(i):
	return alphabet[i]
