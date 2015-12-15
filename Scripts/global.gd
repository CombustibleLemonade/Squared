extends Node

var version_major
var version_minor

var possible_colors = ["red", "green", "blue", "yellow"]
var tile = load("tile.scn")

var shapes = []
var colors = {
	"empty":Color(0.0, 0.0, 0.0, 0.0),
	"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.7,0.2), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.8, 0.7, 0.0),
	"custom":null}

class mutation:
	var color_name = "" # Name of the color
	var shape = preload("res://Sprites/Squares/circle.png")


var mutation_sets = []
var default_mutation_set = []

var menu
var is_playing = false # Variable that tracks if we are playing a game
var menu_change = false # Has the menu changed before? (used to prevent double presses)

var width = 7 # Default width of grid
var height = 9 # Default height of grid
var drop_time = 4 # Amount of time it takes for one sprite to be dropped

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

func _ready():
	for s in get_files("./Sprites/Squares/"):
		shapes.push_back(load("Sprites/Squares/" + s))
	
	create_default_color_set()

func create_default_color_set():
	default_mutation_set = [
		mutation.new(), 
		mutation.new(), 
		mutation.new(),
		mutation.new()]
	
	default_mutation_set[0].color_name = "red"
	default_mutation_set[1].color_name = "green"
	default_mutation_set[2].color_name = "blue"
	default_mutation_set[3].color_name = "yellow"
	
	default_mutation_set[0].shape = preload("res://Sprites/Squares/square.png")
	default_mutation_set[1].shape = preload("res://Sprites/Squares/circle.png")
	default_mutation_set[2].shape = preload("res://Sprites/Squares/star.png")
	default_mutation_set[3].shape = preload("res://Sprites/Squares/triangle.png")
	
	mutation_sets.push_back(default_mutation_set)

func go_to(var from, var to, var delta):
	return from + (to - from) * pow(0.5, delta*50)
