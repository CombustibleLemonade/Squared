extends Node2D

# Indicates where the next block is going to fall, and what color it will have

var target_cell = Vector2(3, 0)
var next

var parent
var global

func _ready():
	# Initalization here
	global = get_node("/root/global")
	parent = get_parent()
	
	set_process(true) 
	
	global.is_playing = true
	
	get_node("Timer").set_wait_time(global.drop_time)
	get_node("Timer").start()
	
	next = get_parent().get_node("Incoming").tiles[0].color
	next = load("tile.scn").instance()
	
	add_child(next)
	next.set_process(false)
	next.set_color(get_node("/root/global").possible_colors[randi()%4])
	set_color(global.colors[next.color])
	
	pass

func _process(delta):
	var target = parent.grid_to_screen(target_cell)
	
	var d = get_pos() - target
	set_pos(get_pos() - d*25*delta)
	
	if not global.is_playing:
		return
	
	next.set_pos(Vector2(0, -get_node("Timer").get_time_left() * 50000)/(1000 - get_pos().y))
	next.set_rot(get_node("Timer").get_time_left())
	
	pass

# Places a block at the indicated location
func _on_Timer_timeout():
	if target_cell.y == parent.height - 1:
		parent.die()
		return
	
	# Send the next block to the right location
	var target = parent.get_cell(target_cell)
	target.set_color(next.color)
	target.set_pos(next.get_pos()+target.compute_target())
	target.set_rot(fposmod(next.get_rot(), PI/2))
	
	# Then delete it from ourselves
	remove_child(next)
	next.queue_free()
	
	# Now load the next next block from the incoming list
	next = get_node("../Incoming").shift()
	# And add it to ourselves
	add_child(next)
	next.set_process(false)
	
	var next_color_value = get_node("/root/global").colors[next.color]
	set_color(next_color_value)
	
	target_cell.x = randi()%parent.width
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
	
	pass

func set_color(c):
	c[3] = 0.3
	get_node("Arrow").set_modulate(c)
	pass

func check_physics():
	# Checks if the indicator is pointing to the right block
	var cell = parent.get_cell(target_cell)
	
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
	
	pass
