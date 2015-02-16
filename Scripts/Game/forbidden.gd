
extends Node2D

var global

var width = 3
var height = 3

var tiles = []

func _ready():
	# Initialization here
	global = get_node("/root/global")
	
	get_node("root").set_color(global.possible_colors[randi()%(global.possible_colors.size()-1)])
	
	pass
 