extends "submenu.gd"

var record setget set_record

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "delete":
		e.set_name("delete_sure")
		e.set_text("are you sure?")
	elif e.get_name() == "delete_sure":
		e.set_name("delete")
		e.set_text("delete")
		delete()
	if e.get_name() == "replay":
		start_replay()

# Starts playing the replay
func start_replay():
	if main.has_node("game"): # remove the previous game
		main.get_node("game").free()
	
	if main.has_node("replayer"): # remove the previous replay
		main.get_node("replayer").free()
	
	if main.has_node("squares"):
		main.get_node("squares").free()
	
	main.unpause()
	
	var game = preload("res://Scenes/Game/replay.scn").instance()
	
	game.drop_time = record.drop_time
	game.record = record
	
	var setup = global.Setup.new()
	setup.config = dict2inst(record.config)
	setup.scheme = ["@REPLAY"]
	setup.random_seed = record.random_seed
	game.set_setups(setup)
	
	main.add_child(game)

func set_record(r):
	record = r
	get_node("seed").set_text("seed: " + str(record.random_seed))

# TODO
func delete():
	pass
