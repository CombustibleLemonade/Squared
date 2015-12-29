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
		var tile = preload("res://Scenes/Game/square.scn").instance()
		
		tiles.push_back(tile)
		add_child(tile)
		
		tile.set_process(true)
		tile.target_cell = Vector2(0, height-i-1)
		tile.set_pos(tile.compute_target())
		tile.set_mutation(get_node("/root/global").default_mutation_set[get_parent().next_int()%4])

func shift():
	# Delete the last one
	var out = tiles[0]
	remove_child(tiles[0])
	
	# Shift all tiles
	for i in range (1, tiles.size()):
		tiles[i].target_cell += Vector2(0, 1)
		tiles[i-1] = tiles[i]
	
	# Append a new tile
	var color = get_node("/root/global").possible_colors[get_parent().next_int()%4]
	var tile = preload("res://Scenes/Game/square.scn").instance()
	tile.target_cell = Vector2(0, 0)
	
	add_child(tile)
	
	tile.set_process(true)
	tiles[tiles.size()-1] = tile
	tile.set_mutation(get_node("/root/global").default_mutation_set[get_parent().next_int()%4])
	tile.set_pos(tile.compute_target())
	return out
