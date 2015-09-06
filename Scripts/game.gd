extends Node2D

var global

var sprites = {}

var width = 7 # Amount of columns 	-- x
var height = 9 # Amount of rows   	-- y

var scores = []

class Group:
	var color = ""
	var score = 0

func _ready():
	# Initialization
	global = get_node("/root/global")
	
	# Place tiles upon initialization
	randomize()
	
	for x in range (width):
		for y in range (height):
			var sprite = load("tile.scn").instance()
			add_child(sprite)
			
			var rand_color
			if y < 4:
				rand_color = "empty"
			
			rand_color = "empty"
			
			sprite.set_color(rand_color)
			sprite.target_cell = Vector2(x, y)
			
			sprites[Vector2(x, y)] = sprite
	
	# Compute physics
	check_physics()
	
	set_process_input(true)
	set_process(true)
	
	pass

func _process(delta):
	
	get_parent().set_pos(OS.get_video_mode_size()/2)
	var scale = OS.get_video_mode_size().y/600
	get_parent().set_scale(Vector2(scale, scale))
	
	pass

func _input(ev):
	# To handle input
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo and not get_node("DropIndicator/Timer") == null and global.is_playing:
		# Shift rows when arrows are pressed
		if ev.is_action("left"):
			move_row_left(get_node("Sprite").target)
		elif ev.is_action("right"):
			move_row_right(get_node("Sprite").target)
		elif ev.is_action("Next"):
			get_node("DropIndicator")._on_Timer_timeout()
			get_node("DropIndicator/Timer").start()
	
	if not global.is_playing and ev.is_action("Next"):
		get_parent().game_over("You died! Your score was: " + str(global.score))
		queue_free()
	
	if ev.is_action("ui_cancel"):
		compute_score()
		get_parent().game_over("You died! Your score was: " + str(global.score))
		queue_free()
	
	pass

func grid_to_screen(grid):
	return Vector2((grid.x-width/2.0+0.5)*64, -(grid.y-4)*64)
	
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
	
	pass

func compute_score():
	# Make sure only grid is shown
	#get_node("DropIndicator").queue_free()
	#get_node("Incoming").queue_free()
	#get_node("Sprite").queue_free()
	
	var score = 0
	
	while not sprites.empty():
		for i in sprites:
			if sprites.has(i) and not sprites[i].color == "empty":
				var group = find_group(i)
				score += group.size()*(group.size()+1)/2
			elif sprites.has(i):
				sprites.erase(i)
	
	print(score)
	global.score = score
	
	pass

func is_row_filled(var row):
	#for i in range(0, width):
	#	if get_cell(Vector2(i, row)).color == "empty" :
	#		return false
	return true
	pass

func find_group(var vec):
	var color = sprites[vec].color
	var counted = []
	var left_to_do = {}
	
	left_to_do[vec] = sprites[vec]
	
	while true:
		for i in left_to_do:
			counted.push_back(left_to_do[i])
			left_to_do.erase(i)
			sprites.erase(i)
			for j in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1,0)]:
				if sprites.has(i+j) and sprites[i+j].color == color:
					left_to_do[i+j] = sprites[i+j]
		
		if left_to_do.empty():
			break
	
	return counted
	
	pass
 