extends "submenu.gd"

func _ready():
	get_node("config").top_menu = top_menu

func pressed(e):
	if e.get_name() == "start":
		start_game()
	if e.get_name() == "back":
		top_menu.pop_active_menu()

# Starts the game
func start_game():
	if main.has_node("game"): # remove the previous game
		main.get_node("game").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()
	
	main.get_node("selector").hide()
	global.is_playing = true
	
	main.unpause()
	
	var game = preload("res://Scenes/Game/game.scn").instance()
	game.drop_time = get_node("drop_time").value
	
	var config = get_node("config").get_config()
	game.set_config(config)
	
	main.add_child(game)
	top_menu.load_active_menu(null)

# Gets called when the drop_time slider changes position
func drop_time_changed(x_pos):
	var val = tan(x_pos*PI/2 * 0.95) * 4 + 0.1
	get_node("drop_time").set_value(val)
