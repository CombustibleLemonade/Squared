extends "submenu.gd"

func _ready():
	get_node("config").top_menu = top_menu

func pressed(e):
	if e.get_name() == "start":
		start_game()
	if e.get_name() == "back":
		top_menu.pop_active_menu()

func start_game():
	if main.has_node("game"): # remove the previous game
		main.get_node("game").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()
	
	main.get_node("selector").hide()
	global.is_playing = true
	
	top_menu.load_active_menu(null)
	
	main.unpause()
	
	var game = preload("res://Scenes/Game/game.scn").instance()
	var config = get_node("config").get_config()
	game.set_config(config)
	
	main.add_child(game)