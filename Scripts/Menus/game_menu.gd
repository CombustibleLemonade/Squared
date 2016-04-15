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
	
	if main.has_node("replayer"): # remove the previous replay
		main.get_node("replayer").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()
	
	main.unpause()
	
	var game = preload("res://Scenes/Game/versus.scn").instance()
	game.drop_time = get_node("drop_time").value
	
	var config = get_node("config").get_config()
	game.set_config([config])
	
	#game.fields[0].scheme = "default 2"
	
	main.add_child(game)

# Gets called when the drop_time slider changes position
func drop_time_changed(x_pos):
	var val = tan( (x_pos * 0.96 + 0.01)*PI/2 ) * 4
	
	if x_pos == 1:
		val = "inf"
	get_node("drop_time").set_value(val)
