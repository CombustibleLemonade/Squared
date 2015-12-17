extends Node2D

# Node shortcuts
var global
var game
var selector

var sprites = {} # Sprite location : Sprite object
var groups = [] # All groups currently in the game

var target_y = 0 # Target position to vertically scroll to

class Group:
	var color = ""
	var member_count = 1
	var members = []
	var base_member
	var game
	
	# Make all members that should be in this group be part of this group
	# Furthermore, create new groups for split off parts
	func expand():
		var unchecked_members = {base_member.target_cell:base_member} # Members that are queued but have not yet been checked
		var all_members = {base_member.target_cell:base_member} # All members
		base_member.check = true # The base member is already checked, and is already in the unchecked members
		
		var k = 0
		while not unchecked_members.empty():
			for i in unchecked_members:
				k += 1
				var member = unchecked_members[i]
				unchecked_members.erase(i)
				if not member.group == self and not member.group == null:
					member.group.member_count -= 1
					member.group = self
				
				var n = member.neighbors_check(false)
				for j in n:
					unchecked_members[j] = n[j]
					unchecked_members[j].check = true
					all_members[j] = n[j]
		
		for i in range (members.size()-1, -1, -1):
			if all_members.has(members[i].target_cell):
				members.remove(i)
		
		if members.size() > 0:
			members[0].regroup()
		
		member_count = all_members.size()
		members = []
		
		for i in all_members:
			all_members[i].check = false
			members.push_back(all_members[i])
		
		members.sort_custom(self, "sort_vertical")
		for i in range(members.size()):
			members[i].label.set_text(str(i+1))
		pass
	
	func sort_vertical(var a, var b):
		if a.target_cell.y < b.target_cell.y:
			return true
		if a.target_cell.y == b.target_cell.y and a.target_cell.x < b.target_cell.x:
			return true
		return false
	
	func _init(var base):
		base_member = base
		game = base.parent
		game.groups.push_back(self) # Add ourselves to the groups
		color = base_member.color
		expand()

func new_group(var base):
	var group = Group.new(base)
	return group

func _ready():
	# Initialize node shortcuts
	global = get_node("/root/global")
	game = get_parent()
	selector = get_node("selector")
	
	# Place tiles
	randomize()
	for x in range (game.width):
		for y in range (game.height):
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
	get_node("size_indicator").set_size(Vector2(game.width, game.height - 1) * 64 + Vector2(8, 8))
	get_node("size_indicator").set_process(false)
	get_node("size_indicator").set_pos(Vector2(0, -32 * (game.height - 2)))

func _process(delta):
	var target_pos = compute_target_pos()
	set_pos(global.go_to(target_pos, get_pos(), delta))

func _input(ev):
	# To handle input
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo and not get_node("dropindicator/Timer") == null and global.is_playing:
		# Shift rows when arrows are pressed
		if ev.is_action("left"):
			move_row_left(selector.target)
		elif ev.is_action("right"):
			move_row_right(selector.target)
		
		elif ev.is_action("Next"):
			get_node("dropindicator")._on_Timer_timeout()
			get_node("dropindicator/Timer").start()
	
	if ev.is_action_pressed("ui_cancel"):
		game.compute_score()
		game.deactivate()

func move_row_left(row):
	# Will move selected row one element to the left
	var shift = []
	for i in range (game.width-1, -1, -1):
		shift.append(Vector2(i, row))
	
	shift(shift)
	check_physics()

func move_row_right(row):
	# Will move selected row one element to the right 
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
			sprites[i].group.expand()

# checks physics of all sprites, from top to bottom
func check_physics():
	for x in range(0, game.width):
		for y in range (0, game.height):
			sprites[Vector2(x, y)].check_physics()
	
	get_node("dropindicator").check_physics()

# Convert grid coordinates to screen coordinates
func grid_to_screen(grid):
	return Vector2((grid.x-game.width/2.0+0.5)*64, -(grid.y)*64)

# Returns the square at position v
func get_cell(v):
	if v.x < game.width and v.y < game.height and v.x >= 0 and v.y >= 0:
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

func get_focus():
	return target_y-4
