extends Node2D

var sprite
var global

var size_x = 8
var size_y = 4
var fade = 5

func _ready():
	global = get_node("/root/global")
	for y in range(-size_y, size_y + 1):
		add_row(range(-size_x, size_x), y)
	set_process(true)
	pass

func add_row(range_arg, y):
	for x in range_arg:
		var s = global.tile.instance()
		s.target_cell = Vector2(x, y)
		
		add_child(s)
		
		s.set_color(global.possible_colors[randi() % global.possible_colors.size()])
		s.get_node("Sprite").set_texture(global.shapes[randi() % global.shapes.size()])
		
		set_square(s)
		s.set_process(false)
	pass

func set_square(s):
	var x = s.target_cell.x
	var y = s.target_cell.y
	
	s.set_pos(Vector2(x * 70, y * (70 + x * (x - 1) * 0.5)))
	s.set_rot(tan( - x * y / 70.0))
	
	# Make squares fade in/out at the ends
	if x < - size_x + fade:
		s.set_opacity(sin_smooth((x + size_x) / fade))
	if x > size_x - fade:
		s.set_opacity(min(s.get_opacity(), sin_smooth( (- x + size_x) / fade)))
	pass

func sin_smooth(v):
	return (cos(PI*(1-v))+1)/2.0

func _process(delta):
	var all = get_children()
	for square in all:
		if square.target_cell.x > size_x:
			square.target_cell.x -= size_x * 2
		square.target_cell.x += delta * 0.3
		set_square(square)
	pass