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
	var selected = parent.get_active_entry()
	
	if global.menu_change:
		reset_values()
		global.menu_change = false
		return
	
	if not event.is_pressed():
		return
	
	if event.is_echo():
		return
	
	if event.is_action_pressed("ui_accept"):
		if parent.get_active_entry().get_name() == "accept":
			accept()
		if parent.get_active_entry().get_name() == "cancel":
			exit()
			return

func reset_values():
	get_node("width").value = global.width
	get_node("height").value = global.height

func accept():
	global.width = get_node("width").value
	global.height = get_node("height").value
	exit()

func exit():
	parent.set_active_menu(parent.get_node("options_menu"))
	parent.selector.set_target(-parent.get_node("options_menu/gameplay").get_position_in_parent())
	global.menu_change = true
	reset_values()
