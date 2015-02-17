
extends Node2D

var global

var width = 3
var height = 3

var tiles = []

func _ready():
	# Initialization here
	global = get_node("/root/global")
	
	get_node("root").set_color(global.possible_colors[randi()%(global.possible_colors.size()-1)])
	
	var forbidden_pos = global.forbidden_pos
	for i in range (0, 3):
		var new_tile = load("tile.scn").instance()
		add_child(new_tile)
		new_tile.set_color(global.possible_colors[randi()%(global.possible_colors.size()-1)])
		
		var random = randi()%forbidden_pos.size()
		new_tile.target_cell = forbidden_pos[random]
		forbidden_pos.erase(random)
	
	pass
 
func check_law():
	# TODO
	
	
	pass
