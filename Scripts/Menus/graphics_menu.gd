extends "submenu.gd"

func _ready():
	get_node("fullscreen").set(OS.is_window_fullscreen())

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

func set_fullscreen(is_fullscreen):
	OS.set_window_fullscreen(is_fullscreen)