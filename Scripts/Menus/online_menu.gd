extends "submenu.gd"

func pressed(p):
	if p.get_name() == "join":
		activate_join_game()
	if p.get_name() == "host":
		activate_host_game()
	if p.get_name() == "back":
		top_menu.pop_active_menu()

func activate_join_game():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/join_menu.scn")

func activate_host_game():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/host_menu.tscn")
