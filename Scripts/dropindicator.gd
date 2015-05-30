
extends Node2D

# member variables here, example:
var target_cell = Vector2(3, 4)
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
	
	next.set_pos(Vector2(0, -get_node("Timer").get_time_left() * 50000)/(1000 - get_pos().y))
	next.set_rot(get_node("Timer").get_time_left())
	
	pass

func _on_Timer_timeout():
	var target = parent.get_cell(target_cell)
	target.set_color(next.color)
	target.set_pos(next.get_pos()+target.compute_target())
	target.set_rot(fposmod(next.get_rot(), PI/2))
	
	remove_child(next)
	next.queue_free()
	
	next = get_node("../Incoming").shift()
	add_child(next)
	next.set_process(false)
	
	var next_color_value = get_node("/root/global").colors[next.color]
	set_color(next_color_value)
	
	target_cell.x = randi()%7
	check_physics()
	
	pass

func set_color(c):
	c[3] = 0.3
	get_node("Arrow").set_modulate(c)
	
	pass

func check_physics():
	# Checks if the indicator is pointing to the right block
	var cell = parent.get_cell(target_cell)
	if cell == null and global.is_playing:
		get_node("Timer").queue_free()
		global.is_playing = false
		get_parent().compute_score()
		return
	
	if cell.color != "empty":
		target_cell -= Vector2(0, 1)
		check_physics()
	
	if not global.is_playing:
		return
	
	cell = parent.get_cell(target_cell+Vector2(0, 1))
	
	if cell == null:
		return
	
	if cell.color == "empty":
		target_cell += Vector2(0, 1)
		check_physics()
	
	pass
