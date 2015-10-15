extends Node2D

var global

var sprites = {}

export(int) var width # Amount of columns 	-- x
export(int) var height # Amount of rows 	-- y

var scores = []
var groups = [] # All groups currently in the game

class Group:
	#extends Node
	
	var color = ""
	var member_count = 1
	var members = []
	var base_member
	var game
	
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
		pass
	
	func _init(var base):
		base_member = base
		game = base.parent
		game.groups.push_back(self) # Add ourselves to the groups
		color = base_member.color
		expand()
		pass
	
	func _sort(var a, var b):
		return false

func new_group(var base):
	return Group.new(base)
	pass

func _ready():
	
	# Initialization
	global = get_node("/root/global")
	
	# Place tiles upon initialization
	randomize()
	
	for x in range (width):
		for y in range (height):
			var sprite = global.tile.instance()
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
	var scores = ""
	
	var i = 0
	while i < groups.size():
		if groups[i].member_count > 0:
			scores += str(groups[i].member_count) + "\n"
			i += 1
		else:
			groups.remove(i)
	
	compute_score()
	get_node("Score/Label").set_text(str(global.score))
	
	for i in sprites:
		var s = sprites[i]
		#if not s.group == null:
		#	s.label.set_text(str(s.group.member_count))
	
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
	
	if ev.is_action("ui_page_down"):
		get_tree().set_pause(true)
		#get_node("Sprite").set_size(Vector2(100, 100))
	
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
	
	for i in s:
		if not sprites[i].group == null:
			sprites[i].group.expand()
	
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
	# checks physics of all sprites, from top to bottom
	for x in range(0, width):
		for y in range (0, height):
			sprites[Vector2(x, y)].check_physics()
	
	get_node("DropIndicator").check_physics()
	
	pass

func die():
	# Computes the score and triggers game over
	compute_score()
	get_parent().game_over("You died! Your score was: " + str(global.score))
	queue_free()
	pass

func compute_score():
	var score = 0
	for i in groups:
		score += i.member_count*(i.member_count+1)/2
	global.score = score
	return score
	pass
 