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

var score

func _ready():
	is_playing = false
	var test = [Vector2(0, 0),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(-1, 3),
		Vector2(2, 1),
		Vector2(-1, 2),
		Vector2(3, 3),
		Vector2(4, 0)]
	test.sort_custom(self, "test_func")
	print(test)
	pass

func test_func(var a, var b):
	print("a: " + str(a) + " b: " + str(b))
	if (a.x < b.x):
		return true
	
	return false
	pass