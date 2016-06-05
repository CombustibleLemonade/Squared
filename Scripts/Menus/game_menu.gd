extends "submenu.gd"

var config_buttons = []
var configs = []
var player_count = 1

func _ready():
	change_player_count()

func pressed(e):
	if e.get_name() == "start":
		start_game()
	if e.get_name() == "back":
		top_menu.pop_active_menu()

func open_player_config(index):
	var config = preload("res://Scenes/Menus/Submenus/config_menu.scn").instance()
	config.index = index
	config.game_menu = self
	
	top_menu.set_active_menu(config)
	#config.initialize()
	
	delete_player_buttons()

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
	
	var c = []
	for i in range(player_count):
		c.push_back(configs[i])
	game.set_config(c)
	
	main.add_child(game)

# Gets called when the drop_time slider changes position
func drop_time_changed(x_pos):
	var val = tan( (x_pos * 0.96 + 0.01)*PI/2 ) * 4
	
	if x_pos == 1:
		val = "inf"
	get_node("drop_time").set_value(val)

# Changes the player count and the associated buttons
func change_player_count():
	delete_player_buttons()
	
	var player_count_config = get_node("player_count").get_value()
	set_player_count(player_count_config)

# Deletes all player buttons
func delete_player_buttons():
	for c in config_buttons:
		if c.get_parent() == self:
			remove_child(c)
	
	config_buttons = []

# Sets the configuration for the player count
# 0 means singleplayer
# 1 means compete
func set_player_count(mode):
	var button = preload("res://Scenes/Menus/MenuEntries/button.scn")
	
	player_count = 1
	if mode == 1:
		player_count = 2
	
	while configs.size() < player_count:
		configs.push_back(get_node("/root/global").Configuration.new())
	
	for i in range(player_count):
		var player_conf = button.instance()
		player_conf.set_text("player " + str(i + 1))
		player_conf.set_name("p" + str(i + 1) + "config")
		config_buttons.push_back(player_conf)
		
		var index = get_node("player_count").get_index() + 1 + i
		add_child(player_conf)
		move_child(player_conf, index)
		
		player_conf.connect("pressed", self, "open_player_config", [i])
