extends Sprite

# member variables here, example:

var global

var color
var target_cell = Vector2(0, 0)
var parent
var is_falling

func compute_target():
	
	return Vector2((target_cell.x-parent.width/2.0+0.5)*64, (target_cell.y-4)*64)
	
	pass

func set_color(c):
	color = c
	set_modulate(global.colors[c])
	pass

func check_physics():
	# Check if a tile is supported at all
	if not parent == null and target_cell.y < parent.height - 1:
		var support = parent.get_cell(target_cell + Vector2(0, 1))
		if support.color == "empty":
			# Drop down if it's not
			var top = parent.get_cell(target_cell - Vector2())
			drop()
			check_physics()
	
	pass

func drop():
	var s = [target_cell, target_cell + Vector2(0, 1)]
	parent.shift(s)
	
	pass

func _ready():
	# Initalization here
	
	global = get_node("/root/global")
	
	parent = get_parent()
	
	set_process(true)
	pass

func _process(delta):
	var target = compute_target()
	
	var d = get_pos() - target
	set_pos(get_pos() - d*25*delta)
	
	pass