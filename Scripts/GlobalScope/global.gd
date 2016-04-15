extends Node

var version = "alpha 0.1"

signal file_change(path, data)

var possible_colors = ["red", "green", "blue", "yellow"]
var tile = preload("res://Scenes/Game/square.scn")

var leaderboard_path = "user://Leaderboards/leaderboards.save"

var shapes = []
var colors = {
	"empty":Color(0.0, 0.0, 0.0, 0.0),
	"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.7,0.2), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.8, 0.7, 0.0),
	"custom":null}

class Mutation:
	var color_name = "" # Name of the color
	var shape = preload("res://Sprites/Squares/circle.png")

var mutation_sets = []
var default_mutation_set = []

var menu
var is_playing = false # Variable that tracks if we are playing a game
var menu_change = false # Has the menu changed before? (used to prevent double presses)

class Configuration:
	var width = 0
	var height = 0
	
	var mutation_count = 4

var width = 7 # Default width of grid
var height = 8 # Default height of grid

var drop_time = 4 # Amount of time it takes for one sprite to be dropped

func _init():
	randomize()

func _ready():
	for s in get_files("./Sprites/Squares/"):
		shapes.push_back(load("Sprites/Squares/" + s))
	
	create_default_color_set()
	#OS.set_window_fullscreen(true)
	
	var dir = Directory.new()

# Creates the default color set
func create_default_color_set():
	default_mutation_set = [
		Mutation.new(), 
		Mutation.new(), 
		Mutation.new(),
		Mutation.new()]
	
	default_mutation_set[0].color_name = "red"
	default_mutation_set[1].color_name = "green"
	default_mutation_set[2].color_name = "blue"
	default_mutation_set[3].color_name = "yellow"
	
	default_mutation_set[0].shape = preload("res://Sprites/Squares/square.png")
	default_mutation_set[1].shape = preload("res://Sprites/Squares/circle.png")
	default_mutation_set[2].shape = preload("res://Sprites/Squares/star.png")
	default_mutation_set[3].shape = preload("res://Sprites/Squares/triangle.png")
	
	mutation_sets.push_back(default_mutation_set)

# Returns how many vertical entries are stacked in the menu
func get_vertical_entry_count(menu):
	var children = menu.get_children()
	var size = 0 # Extra size from submenu members
	
	var i = 0
	while i < children.size():
		if not children[i].get_name().find("@") == -1:
			children.remove(i)
		else:
			if children[i].get("size") == null:
				size += 1
			else:
				size += children[i].size
			i+=1
	
	return size # Correct for 3 nodes added because it's the main node

# Sort of like lerp, except exponential
func go_to(var from, var to, var delta):
	return from + (to - from) * pow(0.5, delta*50)

## FILE OPERATIONS ##

# Returns all file names in a certain folder
func get_files(var folder):
	var files = []
	var dir = Directory.new()
	
	var error = dir.open("res://" + folder)
	
	dir.list_dir_begin()
	
	var file = dir.get_next()
	while not file == "":
		if not file.find(".png") == -1:
			files.push_back(file)
		file = dir.get_next()
	return files

# Saves data to a file in path
func save_file(path, data):
	var file = File.new()
	
	# Check if the containing directory exists
	var dir = Directory.new()
	dir.open( "user://" )
	
	if not dir.dir_exists(path.get_base_dir()):
		var rel_path = path.get_base_dir()
		dir.make_dir(rel_path)
	
	file.open(path, File.WRITE)
	file.store_var(data)
	file.close()
	
	emit_signal("file_change", path, data)

# Load data from a file in path
func load_file(path):
	var file = File.new()
	var data
	if file.file_exists(path):
		file.open(path, File.READ)
		data = file.get_var()
		return data
	else:
		return null

# Returns all scores of configuration c
func get_scores_of_config(c):
	var data = load_file(leaderboard_path)
	
	var key = inst2dict(c)
	
	if data == null or not data.has(str(inst2dict(c))):
		# If no scores of this config have been stored yet, return empty
		return []
	else:
		# Otherwise, load stuff
		var scores = data[str(inst2dict(c))]
		scores.sort_custom(self, "score_sort")
		return scores

func score_sort(a, b):
	return a.score > b.score

var used_configs = {}

# Gets all configurations that have been played
func get_played_configs():
	var score = File.new()
	var file_content = {}
	if score.file_exists(leaderboard_path):
		score.open(leaderboard_path, File.READ)
		file_content = score.get_var()
		score.close()
		
		file_content = file_content.keys()
		
		var played_config_dict = {}
		
		for i in range(0, file_content.size()):
			var element = file_content[i]
			played_config_dict[element] = dict2inst(element)
		
		file_content = played_config_dict.keys()
		
		return file_content
	else:
		return []

# Deletes all scores of configuration c
func reset_scores_of_config(c):
	var scores = load_file(leaderboard_path)
	
	scores.erase(str(inst2dict(c)))
	
	save_file(leaderboard_path, scores)

# Deletes all scores
func reset_scores():
	var score = File.new()
	var file_content = {}
	if score.file_exists(leaderboard_path):
		score.open(leaderboard_path, File.WRITE)
		score.store_var({})
		score.close()

# Saves the score to the filesystem
func save_score(s, c):
	var data = load_file(leaderboard_path)
	var key = str(inst2dict(c))
	
	if data == null:
		data = {}
	
	if data.has(key):
		data[key].push_back(s)
	else:
		data[key] = [s]
	
	save_file(leaderboard_path, data)
