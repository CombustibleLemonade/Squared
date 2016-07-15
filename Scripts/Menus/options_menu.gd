extends "submenu.gd"

func pressed(e):
	if e.get_name() == "graphics":
		top_menu.load_active_menu("res://Scenes/Menus/Submenus/graphics_menu.scn")
	if e.get_name() == "controls":
		top_menu.load_active_menu("res://Scenes/Menus/Submenus/controls_menu.scn")
	if e.get_name() == "mod folder":
		OS.shell_open("file://")
		print("not supported yet")
	if e.get_name() == "back":
		top_menu.pop_active_menu()
