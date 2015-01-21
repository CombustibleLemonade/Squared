
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

func set_color(c):
	color = c
	set_modulate(colors[c])
	pass

func check_physics():
	# Check if a tile is supported at all
	if not parent == null and target_cell.y < parent.height - 1:
		var support = parent.get_cell(target_cell + Vector2(0, 1))
		if support.color == "empty":
			#print(target_cell.x)
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
	
	parent = get_parent()
	
	set_process(true)
	pass

func _process(delta):
	var target = compute_target()
	
	var d = get_pos() - target
	set_pos(get_pos() - d*0.4)
	
	pass
