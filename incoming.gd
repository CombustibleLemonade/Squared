extends Node2D

var width = 1
var height = 9

func _ready():
	
	randomize()
	
	set_process(true)
	
	for i in range (0, height):
		var tile = load("tile.scn").instance()
		add_child(tile)
		tile.target_cell = Vector2(0, i)
		tile.set_color(get_node("/root/global").possible_colors[randi()%4])
	
	pass

# Todo
func _process():
	
	
	pass

# Todo
func get_cell():
	
	pass
