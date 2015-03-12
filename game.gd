extends Node2D

var global

var sprites = {}

var width = 7 # Amount of columns
var height = 9 # Amount of rows

func _ready():
	# Initialization
	global = get_node("/root/global")
	
	# Place tiles upon initialization
	randomize()
	
	for x in range (width):
		for y in range (height):
			var sprite = load("tile.scn").instance()
			add_child(sprite)
			
			var rand_color = global.possible_colors[randi()%5]
			if y < 4:
				rand_color = "empty"
			
			rand_color = "empty"
			
			sprite.set_color(rand_color)
			sprite.target_cell = Vector2(x, y)
			
			sprites[Vector2(x, y)] = sprite
	
	# Compute physics
	check_physics()
	
	set_process_input(true)
	
	pass

func _input(ev):
	# To handle input
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo:
		# Shift rows when arrows are pressed
		if ev.is_action("left"):
			move_row_left(get_node("Sprite").target)
		elif ev.is_action("right"):
			move_row_right(get_node("Sprite").target)
		elif ev.is_action("Next"):
			get_node("DropIndicator/Timer").start()
			get_node("DropIndicator")._on_Timer_timeout()
	pass

func grid_to_screen(grid):
	return Vector2((grid.x-width/2.0+0.5)*64, (grid.y-4)*64)
	
	pass

func get_cell(v):
	if v.x < width and v.y < height and v.x >= 0 and v.y >= 0:
		return sprites[v]
	pass

func set_cell(v, cell):
	
	sprites[v] = cell
	sprites[v].target_cell = v
	
	pass

func shift(s):
	# Will shift all tiles in s to the next, and the last to the first.
	var out_buf = get_cell(s[s.size()-1])
	var in_buf
	
	for i in range(s.size()-1, 0, -1):
		set_cell(s[i], get_cell(s[i-1]))
	
	set_cell(s[0], out_buf)
	
	pass

func shift_incoming():
	return get_node("Node2D").shift()
	
	pass

func move_row_left(row):
	# Will move selected row one element to the left
	var shift = []
	for i in range (width-1, -1, -1):
		shift.append(Vector2(i, row))
	
	shift(shift)
	check_physics()
	
	pass

func move_row_right(row):
	# Will move selected row one element to the right 
	var shift = []
	
	for i in range (0, width):
		shift.append(Vector2(i, row))
	
	shift(shift)
	check_physics()
	
	pass

func check_physics():
	# checks physics of all sprites
	for i in sprites:
		sprites[i].check_physics()
	
	get_node("DropIndicator").check_physics()
	
	get_node("law").police()
	
	pass
