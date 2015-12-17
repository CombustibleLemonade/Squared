extends Node2D

# Node shortcuts
var global
var selector
var grid

export(int) var width # Amount of columns 	-- x
export(int) var height # Amount of rows 	-- y

var died = false # Have we died yet?

var mutation_set # Set of square color-shapes
var configuration

func _ready():
	# Initialization
	global = get_node("/root/global")
	selector = get_node("grid/selector")
	grid = get_node("grid")
	
	set_process(true)
	
	get_node("incoming").set_pos(Vector2(width*64 + 64, 8*32))
	get_node("Score").set_margin(MARGIN_LEFT, width*32+200)
	get_node("Score").set_margin(MARGIN_RIGHT, width*32+100)
	grid.set_focus(0)
	grid.get_node("selector").max_y = height - 2
	
	reset_scores_of_config(0)
	
	configuration = preload("global.gd").Configuration.new()
	configuration.width = width
	configuration.height = height
	
	print(get_scores_of_config(configuration))

func _process(delta):
	var scores = ""
	var i = 0
	while i < grid.groups.size():
		if grid.groups[i].member_count > 0:
			scores += str(grid.groups[i].member_count) + "\n"
			i += 1
		else:
			grid.groups.remove(i)
	
	get_node("Score/Label").set_text(str(compute_score()))

# Computes the score and triggers game over
func die():
	var score = compute_score()
	save_score(score, configuration)
	
	died = true
	deactivate()

# Will pause the game in the background, and display the main menu in the foreground
func deactivate():
	get_tree().set_pause(true)
	set_pause_mode(1)
	get_parent().pause()

# Computes the score
func compute_score():
	var score = 0
	for i in get_node("grid").groups:
		score += i.member_count*(i.member_count+1)/2
	return score

# Saves the score to the filesystem
func save_score(s, c):
	var score = File.new()
	var scoreconfig = inst2dict(c)
	var file_content = {}
	
	if score.file_exists("user://savegame.save"):
		score.open("user://savegame.save", File.READ)
		file_content = score.get_var()
		
		if typeof(file_content) == typeof([]):
			file_content = {scoreconfig : [s]}
			score.store_var(file_content)
			return
		
		if file_content.has(scoreconfig):
			file_content[scoreconfig].push_back(scoreconfig)
		else:
			file_content[scoreconfig] = [s]
		score.close()
	
	score.open("user://savegame.save", File.WRITE)
	score.store_var(file_content)
	score.close()

# Returns all scores of configuration c
func get_scores_of_config(c):
	var score = File.new()
	var file_content
	if score.file_exists("user://savegame.save"):
		score.open("user://savegame.save", File.READ)
		file_content = score.get_var()
		
		var keys = file_content.keys()
		var values = []
		for i in keys:
			if str(i) == str(inst2dict( c )):
				values.push_back(file_content[i])
		
		return values
	else:
		return []

# Gets all configurations that have been played
func get_played_configs():
	var score = File.new()
	var file_content = {}
	if score.file_exists("user://savegame.save"):
		score.open("user://savegame.save", File.READ)
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
	var score = File.new()
	var file_content = {}
	if score.file_exists("user://savegame.save"):
		score.open("user://savegame.save", File.READ)
		file_content = score.get_var()
		file_content.erase(c)
		score.close()
		
		score.open("user://savegame.save", File.WRITE)
		score.store_var(file_content)
		score.close()

# Deletes all scores
func reset_scores():
	var score = File.new()
	var file_content = {}
	if score.file_exists("user://savegame.save"):
		score.open("user://savegame.save", File.WRITE)
		score.store_var({})
		score.close()