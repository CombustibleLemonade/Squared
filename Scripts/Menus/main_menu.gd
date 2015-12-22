extends "submenu.gd"

func _ready():
	set_process_input(true)

func _enter_tree():
	size = get_child_count()
	top_menu = get_parent()

func pressed(e):
	if e.get_name() == "new_game":
		activate_new_game()
	if e.get_name() == "options":
		activate_options()
	elif e.get_name() == "quit":
		get_tree().quit()

func activate_new_game():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/game_menu.scn")

func activate_options():
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/options_menu.scn")