
extends Node2D

var global
# member variables here, example:
var target_cell = Vector2(3, 4)
var next_color = "red"

var parent

func _ready():
	# Initalization here
	get_node("Arrow").set_modulate(Color(1, 1, 1, 0.3))
	parent = get_parent()
	
	set_process(true)
	
	get_node("Timer").start()
	get_node("Timer").set_wait_time(4)
	
	next_color = get_node("/root/Grid/Node2D").tiles[0].color
	
	pass

func _process(delta):
	var target = parent.grid_to_screen(target_cell)
	
	var d = get_pos() - target
	set_pos(get_pos() - d*25*delta)
	
	pass

func _on_Timer_timeout():
	
	parent.get_cell(target_cell).set_color(next_color)
	next_color = parent.shift_incoming()
	check_physics()
	
	pass

func check_physics():
	# Checks if the indicator is pointing to the right block
	var cell = parent.get_cell(target_cell)
	if cell.color != "empty":
		target_cell -= Vector2(0, 1)
	
	cell = parent.get_cell(target_cell+Vector2(0, 1))
	if cell.color == "empty":
		target_cell += Vector2(0, 1)
	
	pass
