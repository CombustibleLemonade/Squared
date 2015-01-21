extends Node2D

var sprites = []

var width = 5
var height = 9

var select # Bar node that hovers over the tiles

func _ready():
	# Initalization here
	
	select = load("selector.scn").instance()
	
	for y in range (height):
		
		var spriterow = []
		
		for x in range (width):
			var sprite = load("tile.scn").instance()
			sprite.set_pos(Vector2(x*64-width*32 + 32, y*64-height*32+32))
			
			var rand_color = sprite.possible_colors[randi()%4]
			if (y < 4):
				rand_color = sprite.possible_colors[3]
			sprite.set_tile_color(rand_color)
			
			sprite.target_cell = Vector2(x, y) 
			
			spriterow.append(sprite)
			
			add_child(sprite)
			randomize()
		
		sprites.append(spriterow)
	
	add_child(select)
	
	#for a in sprites:
		#for b in a:
			#b.check_physics()
	
	set_process_input(true)
	
	pass

func _input(ev):
	# To handle input
	
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo:
		if ev.is_action("up"):
			select.move(1)
		elif ev.is_action("down"):
			select.move(-1)
		elif ev.is_action("left"):
			move_row_left(sprites[select.target])
		elif ev.is_action("right"):
			move_row_right(sprites[select.target])
	
	pass

func move_row_left(x):
	# Shift all tiles
	var buffer = x[0]
	for i in range (1, width):
		x[i-1] = x[i]
		x[i-1].shift(-1)
	
	buffer.shift(width-1)
	x[width-1] = buffer
	pass

func move_row_right(x):
	# Shift all tiles
	var buffer = x[width-1]
	for i in range (width-2, -1, -1):
		x[i+1] = x[i]
		x[i+1].shift(1)
	buffer.shift(-width+1)
	x[0] = buffer
	pass

func get_cell_v(v):
	
	if v.x < width and v.x >= 0 and v.y < height and v.y >=0:
		return sprites[v.y][v.x]
	return sprites[0][0]
	
	pass

func set_cell_v(v, cell):
	if v.x < width and v.x >= 0 and v.y < height and v.y >=0:
		sprites[v.y][v.x] = cell
		cell.target_cell = v
	
	pass


func switch_cell_v(v1, v2):
	
	print (v1, " ", v2)
	print (get_cell_v(v1).color, " ", get_cell_v(v2).color)
	
	var buffer = get_cell_v(v1)
	set_cell_v(v1, get_cell_v(v2))
	set_cell_v(v2, buffer)
	
	pass
