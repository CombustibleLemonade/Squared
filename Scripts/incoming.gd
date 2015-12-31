extends Node2D

# Will store and show a list of what blocks fall next

var width = 1
var height = 9

var tiles = []

func _ready():
	
	randomize()
	
	set_process(true)
	
	# Add the initial random tiles to the incoming list
	for i in range (0, height):
		var tile = new_square()
		
		tiles.push_back(tile)
		
		tile.target_cell = Vector2(0, height-i-1)
		tile.set_pos(tile.compute_target())

func shift():
	# Delete the last one
	var out = tiles[0]
	remove_child(tiles[0])
	
	# Shift all tiles
	for i in range (1, tiles.size()):
		tiles[i].target_cell += Vector2(0, 1)
		tiles[i-1] = tiles[i]
	
	var tile = new_square()
	tile.target_cell = Vector2(0, 0)
	
	tiles[tiles.size()-1] = tile
	tile.set_pos(tile.compute_target())
	
	return out

# Creates a new square
func new_square():
	var color = get_node("/root/global").possible_colors[get_parent().next_int()%4]
	var pos = get_parent().next_int()%get_parent().width
	var square = preload("res://Scenes/Game/square.scn").instance()
	
	square.set_text(str(pos))
	square.set_process(true)
	add_child(square)
	
	square.set_mutation(get_node("/root/global").default_mutation_set[get_parent().next_int()%4])
	return square
