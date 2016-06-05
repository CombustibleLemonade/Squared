extends "submenu.gd"

var index = 0 
var game_menu = null
var initialized = false

var config setget set_config, get_config

func _ready():
	get_node("width").set_value(get_config().width)
	get_node("height").set_value(get_config().height)
	initialized = true
	
	update_config()

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "leaderboard":
		activate_leaderboard()

func set_config(c):
	game_menu.configs[index] = c

func get_config():
	return game_menu.configs[index]

func update_config():
	if not initialized:
		return
	
	var c = get_node("/root/global").Configuration.new()
	
	c.width = get_node("width").value
	c.height = get_node("height").value
	
	set_config(c)
	
	var scores = get_node("/root/global").get_scores_of_config(c)
	if not scores.size() == 0:
		get_node("leaderboard").text = "high-score: " + str(scores[0].score)
	else:
		get_node("leaderboard").text = "high-score: null"

# Activates the leaderboard
func activate_leaderboard():
	var leaderboard = preload("res://Scenes/Menus/Submenus/leaderboard.scn").instance()
	top_menu.set_active_menu(leaderboard)
	leaderboard.set_config(get_config())
