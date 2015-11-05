extends Node2D

# Node shortcuts
var global
var selector
var grid

export(int) var width # Amount of columns 	-- x
export(int) var height # Amount of rows 	-- y

var died = false # Have we died yet?

func _ready():
	# Initialization
	global = get_node("/root/global")
	selector = get_node("grid/selector")
	grid = get_node("grid")
	
	set_process(true)
	
	get_node("incoming").set_pos(Vector2(width*64 + 64, 8*32))
	get_node("Score").set_margin(MARGIN_LEFT, width*32+200)
	get_node("Score").set_margin(MARGIN_RIGHT, width*32+100)
	grid.set_focus(0)
	grid.get_node("selector").max_y = height - 1
	pass

func _process(delta):
	var scores = ""
	var i = 0
	while i < grid.groups.size():
		if grid.groups[i].member_count > 0:
			scores += str(grid.groups[i].member_count) + "\n"
			i += 1
		else:
			grid.groups.remove(i)
	
	compute_score()
	get_node("Score/Label").set_text(str(global.score))
	pass

# Computes the score and triggers game over
func die():
	compute_score()
	died = true
	deactivate()
	pass

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	get_tree().set_pause(true)
	set_pause_mode(1)
	get_parent().pause()
	pass

# Computes the score
func compute_score():
	var score = 0
	for i in get_node("grid").groups:
		score += i.member_count*(i.member_count+1)/2
	global.score = score
	return score
 