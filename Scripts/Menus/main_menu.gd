extends "submenu.gd"

func _ready():
	set_process_input(true)

func _enter_tree():
	size = get_child_count()
	top_menu = get_parent()

func pressed(e):
	if e.get_name() == "local_game":
		activate_new_game()
	if e.get_name() == "online_game":
		activate_online_game()
	if e.get_name() == "options":
		activate_options()
	if e.get_name() == "credits":
		activate_credits()
	elif e.get_name() == "quit":
		get_tree().quit()

func activate_new_game():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/game_menu.scn")

func activate_online_game():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/online_menu.scn")

func activate_options():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/options_menu.scn")

func activate_credits():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/credits_menu.scn")
