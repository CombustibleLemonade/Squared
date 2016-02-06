extends "submenu.gd"

signal highscores(c)

func _ready():
	apply_highscore()
	get_node("/root/global").connect("file_change", self, "on_file_change")

# Sets the score
func on_file_change(path, data):
	if not is_inside_tree():
		return
	
	apply_highscore()

# Puts the high-score on the high-score button
func apply_highscore():
	var c = get_config()
	
	var scores = get_node("/root/global").get_scores_of_config(c)
	
	if not scores.size() == 0:
		get_node("high-score").text = "high-scores: " + str(scores[0].score)
	else:
		get_node("high-score").text = "high-scores: null"

# Gets the config of the selected parameters
func get_config():
	var c = preload("../GlobalScope/global.gd").Configuration.new()
	
	if get_node("width") == null:
		return c
	
	c.width = get_node("width").value
	c.height = get_node("height").value
	
	return c

# Activates the leaderboard
func activate_leaderboard():
	var leaderboard = preload("res://Scenes/Menus/Submenus/leaderboard.scn").instance()
	top_menu.set_active_menu(leaderboard)
	leaderboard.set_config(get_config())
