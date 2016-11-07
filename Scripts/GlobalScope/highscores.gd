extends Node

var leaderboard_path = "user://Leaderboards/leaderboards.save"
onready var global = get_node("/root/global")

# Returns all scores of configuration c
func get_scores_of_config(c):
	var data = global.load_file(leaderboard_path)
	
	var key = inst2dict(c)
	
	if data == null or not data.has(str(inst2dict(c))):
		# If no scores of this config have been stored yet, return empty
		return []
	else:
		# Otherwise, load stuff
		var scores = data[str(inst2dict(c))]
		scores.sort_custom(self, "score_sort")
		return scores

func score_sort(a, b):
	return a.score > b.score

var used_configs = {}

# Gets all configurations that have been played
func get_played_configs():
	var score = File.new()
	var file_content = {}
	if score.file_exists(leaderboard_path):
		score.open(leaderboard_path, File.READ)
		file_content = score.get_var()
		score.close()
		
		file_content = file_content.keys()
		
		var played_config_dict = {}
		
		for i in range(0, file_content.size()):
			var element = file_content[i]
			played_config_dict[element] = dict2inst(element)
		
		file_content = played_config_dict.keys()
		
		return file_content
	else:
		return []

# Deletes all scores of configuration c
func reset_scores_of_config(c):
	var scores = global.load_file(leaderboard_path)
	
	# If there are no scores, we can't reset them
	if scores == null:
		return
	
	scores.erase(str(inst2dict(c)))
	
	global.save_file(leaderboard_path, scores)

# Deletes all scores
func reset_scores():
	var score = File.new()
	var file_content = {}
	if score.file_exists(leaderboard_path):
		score.open(leaderboard_path, File.WRITE)
		score.store_var({})
		score.close()

# Saves the score to the filesystem
func save_score(s, c):
	var data = global.load_file(leaderboard_path)
	var key = str(inst2dict(c))
	
	if data == null:
		data = {}
	
	if data.has(key):
		data[key].push_back(s)
	else:
		data[key] = [s]
	
	global.save_file(leaderboard_path, data)
