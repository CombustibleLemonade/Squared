extends "submenu.gd"

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
