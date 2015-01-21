
extends Sprite

# member variables here, example:

var possible_colors = ["red", "green", "blue", "empty"]

var color
var target_cell
var parent

func compute_target():
	
	return Vector2((target_cell.x-2)*64, (target_cell.y-4)*64)
	
	pass

var colors = {"red":Color(0.8,0.2,0.1),
	"green":Color(0,0.8,0.1), 
	"blue":Color(0.0,0.4,0.8),
	"empty":Color(0.0, 0.0, 0.0, 0.0)}

func set_tile_color(c):
	color = c
	set_modulate(colors[c])
	pass

func _ready():
	# Initalization here
	
	parent = get_parent()
	
	set_process(true)
	pass

func _process(delta):
	var target = compute_target()
	
	var d = get_pos() - target
	set_pos(get_pos() - d*0.5)
	
	pass

func shift(offset):
	print (target_cell)
	target_cell.x += offset
	check_physics()
	pass

func check_physics():
	
	if not color == "empty" and not target_cell.y == parent.height-1 and parent.get_cell_v(target_cell + Vector2(0,1)).color == "empty":
		drop()
	
	pass

func drop():
	
	pass
