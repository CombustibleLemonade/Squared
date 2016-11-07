extends Node

var version = "alpha 0.1"

signal file_change(path, data)

var tile = preload("res://Scenes/Game/square.scn")
var sounds = preload("res://Sounds/singleton.scn").instance()

onready var main = get_node("/root/main")

var shapes = []
var colors = {
	"empty":Color(0.0, 0.0, 0.0, 0.0),
	"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.7,0.2), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.8, 0.7, 0.0),
	"purple":Color(0.7, 0.2, 0.8),
	"custom":null}

class Mutation:
	var color_name = "" setget set_color_name # Name of the color
	var color
	var shape = preload("res://Sprites/Squares/circle.png")
	
	func set_color_name(n):
		color_name = n

var mutation_sets = []
var default_mutation_set = []

var menu
var is_playing = false # Variable that tracks if we are playing a game
var menu_change = false # Has the menu changed before? (used to prevent double presses)

# This class describes the key to distinguish leaderboards
class Configuration:
	var player_count = 1
	
	var width = []
	var height = []
	var mutation_count = []

# This class fully describes a played game
class Setup:
	var drop_time = [4, 4, 4, 4]
	var random_seed = 0
	var scheme = []
	var config = Configuration.new()

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

# Creates the default color set
func create_default_color_set():
	default_mutation_set = [
		Mutation.new(), 
		Mutation.new(), 
		Mutation.new(),
		Mutation.new(),
		Mutation.new()]
	
	default_mutation_set[0].color_name = "red"
	default_mutation_set[1].color_name = "green"
	default_mutation_set[2].color_name = "blue"
	default_mutation_set[3].color_name = "yellow"
	default_mutation_set[4].color_name = "purple"
	
	default_mutation_set[0].shape = preload("res://Sprites/Squares/square.png")
	default_mutation_set[1].shape = preload("res://Sprites/Squares/circle.png")
	default_mutation_set[2].shape = preload("res://Sprites/Squares/star.png")
	default_mutation_set[3].shape = preload("res://Sprites/Squares/triangle.png")
	default_mutation_set[4].shape = preload("res://Sprites/Squares/square45.png")
	
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
func go_to(from, to, delta):
	return from + (to - from) * pow(0.5, delta*50)

# inst2dict, but also turns all values into dictionaries, and theirs, etc.
func inst3dict(inst):
	var dict = inst
	
	if typeof(dict) == TYPE_OBJECT:
		dict = inst2dict(inst)
		
		for k in dict.keys():
			dict[k] = inst3dict(dict[k])
	
	return dict

# dict2inst, but inverted for inst3dict
func dict3inst(dict):
	var inst = dict
	
	for k in inst.keys():
		if typeof(inst[k]) == TYPE_DICTIONARY:
			inst[k] = dict3inst(inst[k])
	
	inst = dict2inst(inst)

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

## MENU OPERATIONS ##

func start_game(setup):
	clear_mess()

# Clears things that obstruct a new game
func clear_mess():
	if main.has_node("game"): # remove the previous game
		main.get_node("game").free()
	
	if main.has_node("replayer"): # remove the previous replay
		main.get_node("replayer").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()

