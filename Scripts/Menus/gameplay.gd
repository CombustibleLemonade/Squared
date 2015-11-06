
extends VBoxContainer

var global
var parent

class gameplay_config:
	var width
	var height
	

func _ready():
	global = get_node("/root/global")
	parent = get_parent()
	
	reset_values()
	pass

func _input(event):
	var selected = parent.get_selected()
	
	if global.menu_change:
		reset_values()
		global.menu_change = false
		return
	
	if not event.is_pressed():
		return
	
	if event.is_echo():
		return
	
	if event.is_action_pressed("ui_accept"):
		if parent.get_selected() == "accept":
			accept()
		if parent.get_selected() == "cancel":
			exit()
			return
	
	if event.is_action_pressed("ui_left") and parent.get_selected() == "width":
		get_node("width").value -= 1
	if event.is_action_pressed("ui_right") and parent.get_selected() == "width":
		get_node("width").value += 1
	if event.is_action_pressed("ui_left") and parent.get_selected() == "height":
		get_node("height").value -= 1
	if event.is_action_pressed("ui_right") and parent.get_selected() == "height":
		get_node("height").value += 1
	pass

func reset_values():
	get_node("width").value = global.width
	get_node("height").value = global.height
	pass

func accept():
	global.width = get_node("width").value
	global.height = get_node("height").value
	exit()
	pass

func exit():
	parent.set_active_menu(parent.get_node("options_menu"))
	parent.selector.set_target(-parent.get_node("options_menu/gameplay").get_position_in_parent())
	global.menu_change = true
	reset_values()
	pass