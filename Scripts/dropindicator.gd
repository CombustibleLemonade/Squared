extends Node2D

# Indicates where the next block is going to fall, and what color it will have
var target_cell = Vector2(0, 0)
var next

var parent
var game
var global

func _ready():
	# Initalization here
	parent = get_parent()
	game = get_parent().get_parent()
	global = get_node("/root/global")
	
	set_process(true) 
	
	global.is_playing = true
	
	get_node("Timer").set_wait_time(global.drop_time)
	get_node("Timer").start()
	
	next = game.get_node("incoming").tiles[0].color
	next = load("tile.scn").instance()
	
	add_child(next)
	next.set_process(false)
	next.set_mutation(get_node("/root/global").default_mutation_set[randi()%4])
	set_color(global.colors[next.color])

func _process(delta):
	var target = parent.grid_to_screen(target_cell)
	
	set_pos(global.go_to(target, get_pos(), delta))
	
	if not global.is_playing:
		return
	
	next.set_pos(Vector2(0, -get_node("Timer").get_time_left() * 50000)/(1000 - get_pos().y))
	next.set_rot(get_node("Timer").get_time_left())

# Places a block at the indicated location
func _on_Timer_timeout():
	if target_cell.y == game.height - 1:
		game.die()
		return
	
	# Send the next block to the right location
	var target = parent.get_cell(target_cell)
	target.set_mutation(next.mutation)
	target.set_pos(next.get_pos()+target.compute_target())
	target.set_rot(fposmod(next.get_rot(), PI/2))
	
	# Then delete it from ourselves
	remove_child(next)
	next.free()
	
	# Now load the next next block from the incoming list
	next = get_node("../../incoming").shift()
	
	# And add it to ourselves
	add_child(next)
	next.set_process(false)
	
	var next_color_value = get_node("/root/global").colors[next.color]
	set_color(next_color_value)
	
	target_cell.x = randi()%game.width
	check_physics()
	
	var grouped = false # Has this square been placed in a group yet
	for i in target.neighbors():
		target.group = parent.get_cell(i).group
		target.check = parent.get_cell(i).check
		target.group.expand()
		grouped = true
		break
	
	if not grouped:
		target.regroup()

func set_color(c):
	get_node("Arrow").set_modulate(c)

func check_physics():
	# Checks if the indicator is pointing to the right block
	var cell = get_parent().get_cell(target_cell)
	
	if cell.color != "empty":
		target_cell += Vector2(0, 1)
		check_physics()
	
	if not global.is_playing:
		return
	
	cell = parent.get_cell(target_cell-Vector2(0, 1))
	
	if cell == null:
		return
	
	if cell.color == "empty":
		target_cell -= Vector2(0, 1)
		check_physics()
