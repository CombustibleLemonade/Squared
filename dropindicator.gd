
extends Node2D

# member variables here, example:
var target_cell = Vector2(3, 4)
var next_color = "red"

var parent
var global

func _ready():
	# Initalization here
	global = get_node("/root/global")
	parent = get_parent()
	
	set_process(true)
	
	get_node("Timer").set_wait_time(4)
	get_node("Timer").start()
	
	next_color = get_parent().get_node("Node2D").tiles[0].color
	set_color(global.colors[next_color])
	
	pass

func _process(delta):
	var target = parent.grid_to_screen(target_cell)
	
	var d = get_pos() - target
	set_pos(get_pos() - d*25*delta)
	
	pass

func _on_Timer_timeout():
	
	parent.get_cell(target_cell).set_color(next_color)
	next_color = parent.shift_incoming()
	
	var next_color_value = get_node("/root/global").colors[next_color]
	set_color(next_color_value)
	
	target_cell.x = randi()%6
	check_physics()
	
	pass

func set_color(c):
	c[3] = 0.3
	get_node("Arrow").set_modulate(c)
	
	pass

func check_physics():
	# Checks if the indicator is pointing to the right block
	var cell = parent.get_cell(target_cell)
	if cell.color != "empty":
		target_cell -= Vector2(0, 1)
		check_physics()
	
	cell = parent.get_cell(target_cell+Vector2(0, 1))
	if cell.color == "empty":
		target_cell += Vector2(0, 1)
		check_physics()
	
	pass
