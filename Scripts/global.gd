extends Node

# Contains the global variables for the game

var version_major
var version_minor

var possible_colors = ["red", "green", "blue", "yellow", "empty"]
var tile = load("tile.scn")

var i = 0

var colors = {
	"empty":Color(0.0, 0.0, 0.0, 0.0),
	"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.8,0.1), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.7, 0.7, 0.0)}

var menu
var is_playing
var drop_time = 4 #amount of time it takes for one sprite to be dropped
var menu_change = false # Has the menu changed before? (used to prevent double presses)

var score

var width = 7
var height = 9

func _ready():
	is_playing = false
	pass

func go_to(var from, var to, var delta):
	return from + (to-from) * pow(0.3, delta*50)
