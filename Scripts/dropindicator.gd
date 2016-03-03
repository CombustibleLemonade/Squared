extends Node2D

# Indicates where the next block is going to fall, and what color it will have
var target_cell = Vector2(0, 0)
var next

var parent
var game
var global

var time_left setget set_time_left, get_time_left

func _ready():
	# Initalization here
	parent = get_parent()
	game = get_parent().get_parent()
	global = get_node("/root/global")
	
	set_process(true) 
	
	global.is_playing = true
	
	if typeof(game.drop_time) == typeof(0.0):
		set_time_left(game.drop_time)
		get_node("Timer").start()
	
	fetch_next()

func _process(delta):
	var target = parent.grid_to_screen(target_cell)
	
	set_pos(global.go_to(target, get_pos(), delta))
	
	if typeof(game.drop_time) == typeof(0.0):
		# Drop time is finite
		var tl
		if game.is_replay:
			tl = time_left
		else:
			tl = get_node("Timer").get_time_left()
		
		next.set_pos(Vector2(0, -tl * 50000)/1000)
		next.set_rot(tl)
	else:
		# Drop time is infinite
		get_node("Timer").stop()
		next.set_pos(Vector2(0, -200))

func _on_Timer_timeout():
	on_Timer_timeout()

# Places a block at the indicated location
func on_Timer_timeout():
	game.record.save_event("drop")
	
	if target_cell.y == game.height:
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
	
	fetch_next()
	
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
	
	if typeof(game.drop_time) == typeof("inf") and game.drop_time == "inf":
		get_node("Timer").stop()
	else:
		set_time_left(game.drop_time)

# Loads the next block from the incoming list
func fetch_next():
	next = get_node("../../incoming").shift()
	
	add_child(next)
	next.set_process(false)
	
	var next_color_value = get_node("/root/global").colors[next.color]
	set_color(next_color_value)
	
	target_cell.x = int(next.get_text())
	next.set_text("")

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

func set_time_left(t):
	get_node("Timer").set_wait_time(t)
	if not game.is_replay:
		get_node("Timer").start()
	else:
		get_node("Timer").stop()
	time_left = t

func get_time_left():
	if game.is_replay:
		return time_left
	else:
		return get_node("Timer").get_time_left()
