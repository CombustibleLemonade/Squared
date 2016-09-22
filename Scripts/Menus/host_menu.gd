extends "submenu.gd"

var playercount setget set_player_count

func _ready():
	set_player_count(1)

func pressed(e):
	if e.get_name() == "game_settings":
		open_settings()
	if e.get_name() == "back":
		top_menu.pop_active_menu()

# Opens the setup for the game
func open_settings():
		var menu = load("res://Scenes/Menus/Submenus/game_menu.scn").instance()
		top_menu.set_active_menu(menu)
		menu.set_online(true)

# Sets the player count
func set_player_count(n):
	playercount = n
	var text
	if n == 1:
		text = "1 player"
	else:
		text = str(n) + " players"
	
	get_node("players").set_text(text)