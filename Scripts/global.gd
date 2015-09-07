extends Node

var version_major
var version_minor

var possible_colors = ["red", "green", "blue", "yellow", "empty"]
var tile = load("tile.scn")

var deltaMax = 0
var a = Vector2()
var b = Vector2()

var i = 0

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
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		deltaMax = 0
	i += 1
	if (i % 60 == 0):
		print(deltaMax, " -- a --  ", a, " -- b -- ", b)
	pass
