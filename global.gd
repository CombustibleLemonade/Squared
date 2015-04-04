extends Node

var possible_colors = ["red", "green", "blue", "yellow", "empty"]
var colors = {"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.8,0.1), 
	"blue":Color(0.0,0.4,0.8),
	"yellow":Color(0.7, 0.7, 0.0),
	"empty":Color(0.0, 0.0, 0.0, 0.0)}
var forbidden_pos = [Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), 
	Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(0, 1)]
var menu
var is_playing

func _ready():
	is_playing = false
	pass
