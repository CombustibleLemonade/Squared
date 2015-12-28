extends "submenu.gd"

var record

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "replay":
		start_replay()

func start_replay():
	print("asdf")
	
	if main.has_node("game"): # remove the previous game
		main.get_node("game").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()
	
	main.unpause()
	
	var game = preload("res://Scenes/Game/game.scn").instance()
	game.drop_time = record.drop_time
	game.set_config(dict2inst(record.config))
	main.add_child(game)
