extends Node2D

var sprites = {}

var width = 5
var height = 9

var select # Bar node that hovers over the tiles

func _ready():
	# Initialization
	
	for x in range (width):
		for y in range (height):
			var sprite = load("tile.scn").instance()
			
			var rand_color = sprite.possible_colors[randi()%4]
			if y < 4:
				rand_color = "empty"
			sprite.set_color(rand_color)
			sprite.target_cell = Vector2(x, y)
			
			sprites[Vector2(x, y)] = sprite
			if not rand_color == "empty":
				add_child(sprite)
			randomize()
	
	select = load("selector.scn").instance()
	add_child(select)
	
	for i in sprites:
		sprites[i].check_physics()
	
	set_process_input(true)
	
	pass

func _input(ev):
	# To handle input
	
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo:
		if ev.is_action("left"):
			move_row_left(select.target)
		elif ev.is_action("right"):
			move_row_right(select.target)
	
	var s = {Vector2(5,0):Vector2(5,1)}
	
	pass

func get_cell(v):
	return sprites[v]
	pass

func set_cell(v, cell):
	
	sprites[v] = cell
	sprites[v].target_cell = v
	
	pass

func shift(s):
	
	var out_buf = get_cell(s[s.size()-1])
	var in_buf
	
	for i in range(s.size()-1, 0, -1):
		set_cell(s[i], get_cell(s[i-1]))
	
	
	set_cell(s[0], out_buf)
	
	pass

func move_row_left(row):
	
	var shift = []
	for i in range (width-1, -1, -1):
		shift.append(Vector2(i, row))
	
	shift(shift)
	
	for i in shift:
		var sprite = sprites[i]
		if sprite.color == "empty":
			sprites[i-Vector2(0, 1)].check_physics()
		else:
			sprites[i].check_physics()
	
	pass

func move_row_right(row):
	
	var shift = []
	
	for i in range (0, width):
		shift.append(Vector2(i, row))
	
	shift(shift)
	
	for i in sprites:
		sprites[i].check_physics()
	
	pass
