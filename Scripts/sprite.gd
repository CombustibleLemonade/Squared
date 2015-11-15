extends Node2D
var global
var game
var parent
var label

var color

var target_cell = Vector2(0, 0)
var target_rotation = 0

var is_falling
var check = false
var group

func _ready():
	# Initalization here
	global = get_node("/root/global")
	parent = get_parent()
	game = get_parent().get_parent()
	label = get_node("Node2D/Label")
	
	if get_z() > 0:
		print(get_z())
	pass

func _process(delta):
	# Smoothly glide to our target transform
	var target = compute_target()
	set_pos(global.go_to(target, get_pos(), delta))
	set_rot(global.go_to(target_rotation, get_rot(), delta))
	pass

# Compute the target position to slide towards
func compute_target():
	if not target_cell == null:
		return Vector2((target_cell.x-game.width/2.0+0.5)*64, -target_cell.y*64)
	return get_pos()
	pass

func set_color(c):
	color = c
	get_node("Sprite").set_modulate(global.colors[c])
	pass

func set_mutation(m):
	pass

func check_physics():
	if color == "empty":
		return
	
	var physics_change = false # If the sprite has changed
	
	# Check if a tile is supported at all
	if not parent == null and target_cell.y > 0:
		var support = parent.get_cell(target_cell - Vector2(0, 1))
		if support.color == "empty":
			# Drop down if it's not 
			var top = parent.get_cell(target_cell)
			drop()
			check_physics()
			physics_change = true
	
	return physics_change
	pass

func drop():
	# Drop a cell to its proper height
	var s = [target_cell, target_cell - Vector2(0, 1)]
	parent.shift(s)
	
	pass

# Gives all neighbors of the same color
func neighbors():
	# TODO
	var f_group = {}
	var sprites = parent.sprites
	
	for i in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1,0)]:
		if sprites.has(target_cell + i) and sprites[target_cell + i].color == color:
			f_group[i+target_cell] = sprites[i+target_cell]
	
	return f_group

# Same, but with checks. Might be deleted in future
func neighbors_check(var check_arg):
	# TODO
	var f_group = {}
	var sprites = parent.sprites
	
	for i in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1,0)]:
		if sprites.has(target_cell + i) and sprites[target_cell + i].color == color and sprites[target_cell + i].check == check_arg:
			f_group[i+target_cell] = sprites[i+target_cell]
	
	return f_group
	pass

# Make a new group for this node
func regroup():
	group = parent.new_group(self)