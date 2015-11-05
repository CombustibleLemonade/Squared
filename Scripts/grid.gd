extends Node2D

var global
var game

var target_y = 0

func _ready():
	global = get_node("/root/global")
	game = get_parent()
	
	set_process(true)
	pass

func _process(delta):
	var target_pos = compute_target_pos()
	set_pos(global.go_to(target_pos, get_pos(), delta))
	pass

func set_target_cell(cell):
	target_y = cell
	pass

# Gives the target position to move to
func compute_target_pos():
	return Vector2(0, target_y * 64)

func set_focus(height):
	set_target_cell(height+4)
	pass

func get_focus():
	return target_y-4