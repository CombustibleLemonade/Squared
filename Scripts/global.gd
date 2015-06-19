extends Node

var version_major
var version_minor

var possible_colors = ["red", "green", "blue", "yellow", "empty"]

var colors = {
	"empty":Color(0.0, 0.0, 0.0, 0.0),
	"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.8,0.1), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.7, 0.7, 0.0)}

var forbidden_pos = [Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), 
	Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(0, 1)]
var menu
var is_playing
var drop_time = 4 #amount of time it takes for one sprite to be dropped

var score

func _ready():
	is_playing = false
	pass
