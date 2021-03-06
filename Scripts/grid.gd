extends Node2D

# Node shortcuts
var global
var game
var selector

var sprites = {} # Sprite location : Sprite object
var groups = [] # All groups currently in the game

var target_y = 0 # Target position to vertically scroll to

func _ready():
	# Initialize node shortcuts
	global = get_node("/root/global")
	game = get_parent()
	selector = get_node("selector")
	
	# Place tiles
	randomize()
	for x in range (game.width):
		for y in range (game.height + 1):
			var sprite = global.tile.instance()
			add_child(sprite)
			
			sprite.set_color("empty")
			sprite.target_cell = Vector2(x, y)
			sprite.set_process(true)
			
			sprites[Vector2(x, y)] = sprite
	
	# Compute physics
	check_physics()
	
	set_process(true)
	set_process_input(true)
	
	# Set the size indicator
	get_node("size_indicator").set_size(Vector2(game.width, game.height) * 64 + Vector2(8, 8))
	get_node("size_indicator").set_process(false)
	get_node("size_indicator").set_pos(Vector2(0, -32 * (game.height - 1)))

func _process(delta):
	var target_pos = compute_target_pos()
	set_pos(global.go_to(target_pos, get_pos(), delta))

# To handle input
func input(ev):
	var sounding = false # Wether or not to play a sound
	
	if not get_node("dropindicator/Timer") == null and global.is_playing:
		# Shift rows when arrows are pressed
		if "left" in ev:
			move_row_left(selector.target)
			sounding = true
		elif "right" in ev:
			move_row_right(selector.target)
			sounding = true
		
		elif "next" in ev:
			get_node("dropindicator")._on_Timer_timeout()
			get_node("dropindicator/Timer").start()
			sounding = true
	
	if sounding:
		play_sounds()

# Will move selected row one element to the left
func move_row_left(row):
	var shift = []
	for i in range (game.width-1, -1, -1):
		shift.append(Vector2(i, row))
	
	shift(shift)
	check_physics()

# Will move selected row one element to the right 
func move_row_right(row):
	var shift = []
	
	for i in range (0, game.width):
		shift.append(Vector2(i, row))
	
	shift(shift)
	check_physics()

# Will shift all tiles in s to the next, and the last to the first.
func shift(s):
	var out_buf = get_cell(s[s.size()-1])
	var in_buf
	
	for i in range(s.size()-1, 0, -1):
		set_cell(s[i], get_cell(s[i-1]))
	
	set_cell(s[0], out_buf)
	
	for i in s:
		if not sprites[i].group == null:
			sprites[i].has_changed = true

# checks physics of all sprites, from top to bottom
func check_physics():
	for x in range(0, game.width):
		for y in range (0, game.height):
			sprites[Vector2(x, y)].check_physics()
	
	get_node("dropindicator").check_physics()
	
	for i in sprites:
		if not sprites[i].group == null and sprites[i].has_changed:
			sprites[i].group.expand()
			sprites[i].has_changed = false

# Convert grid coordinates to screen coordinates
func grid_to_screen(grid):
	return Vector2((grid.x-game.width/2.0+0.5)*64, -(grid.y)*64)

# Returns the square at position v
func get_cell(v):
	if v.x < game.width and v.y < game.height + 1 and v.x >= 0 and v.y >= 0:
		return sprites[v]

# Sets the square at position v
func set_cell(v, cell):
	sprites[v] = cell
	sprites[v].target_cell = v

# Sets the vertical position the grid will slide to
func set_target_y(y):
	target_y = y

# Gives the target position to move to
func compute_target_pos():
	return Vector2(0, target_y * 64)

# Sets the focus point the grid will slide to
func set_focus(height):
	set_target_y(height+4)

# Gets the bar of the grid that is in the middle of the screen?
func get_focus():
	return target_y-4

# Plays sounds according to the group sizes
func play_sounds():
	for g in groups:
		var voice = global.sounds.play("note")
		var pitch = pow(2, (g.member_count - 4.5)/6.0)
		
		global.sounds.set_pitch_scale(voice, pitch)

