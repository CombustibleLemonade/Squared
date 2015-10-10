extends Node2D

var global

var color
var target_cell = Vector2(0, 0)
var parent
var is_falling
var check = false
var group
var label

func _ready():
	# Initalization here
	global = get_node("/root/global")
	parent = get_parent()
	label = get_node("Node2D/Label")
	
	set_process(true)
	pass

func _process(delta):
	var target = compute_target()
	
	var d = get_pos() - target
	
	set_pos(get_pos() - d*25*delta)
	
	set_rot(get_rot()*0.5)
	
	pass

# Compute the target position to slide towards
func compute_target():
	return Vector2((target_cell.x-parent.width/2.0+0.5)*64, (-target_cell.y+4)*64)
	pass

func set_color(c):
	color = c
	get_node("Sprite").set_modulate(global.colors[c])
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
	var sprites = get_parent().sprites
	
	for i in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1,0)]:
		if sprites.has(target_cell + i) and sprites[target_cell + i].color == color:
			f_group[i+target_cell] = sprites[i+target_cell]
	
	return f_group
	pass

# Same, but with checks. Might be deleted in future
func neighbors_check(var check_arg):
	# TODO
	var f_group = {}
	var sprites = get_parent().sprites
	
	for i in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1,0)]:
		if sprites.has(target_cell + i) and sprites[target_cell + i].color == color and sprites[target_cell + i].check == check_arg:
			f_group[i+target_cell] = sprites[i+target_cell]
	
	return f_group
	pass

func regroup():
	group = get_parent().new_group(self)