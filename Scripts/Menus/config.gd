extends "submenu.gd"

func _init():
	print("conconconconconconconconconconconconconconcon")

# Puts the high-score on the high-score button
func apply_highscore():
	var c = get_config()
	var scores = get_node("/root/global").get_scores_of_config(c)
	if not scores.size() == 0:
		get_node("high-score").text = "high-scores: " + str(scores[0])
	else:
		get_node("high-score").text = "high-scores: null"

# Gets the config of the selected parameters
func get_config():
	var c = preload("../global.gd").Configuration.new()
	
	if get_node("width") == null:
		return c
	
	c.width = get_node("width").value
	c.height = get_node("height").value
	
	return c
