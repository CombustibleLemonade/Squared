extends "submenu.gd"

var default_schemes = ["defualt 1", "default 2"]
var schemes = default_schemes

var config_buttons = []
var config_menus = []
var player_count = 1

onready var networking = get_node("/root/networking")

func pressed(e):
	if e.get_name() == "start":
		on_start_pressed()
	if e.get_name() == "leaderboard":
		activate_leaderboard()
	if e.get_name() == "back":
		top_menu.pop_active_menu()

# Starts the game
func on_start_pressed():
	load_game()

# Loads the game: no networking lobby required
sync func load_game(setup = get_setup()):
	global.clear_mess()
	main.unpause()
	
	var game = preload("res://Scenes/Game/game.scn").instance()
	
	game.set_setups(setup)
	main.add_child(game)

# Returns the setup for the game
func get_setup():
	var s = global.Setup.new()
	s.config = get_config()
	
	for c in config_menus:
		s.scheme.push_back(c.scheme)
	
	return s

# Returns the config associated with selected menu options
func get_config():
	var conf = global.Configuration.new()
	
	conf.player_count = player_count
	
	for i in range(player_count):
		var c = config_menus[i]
		conf.width.push_back(c.width)
		conf.height.push_back(c.height)
		conf.mutation_count.push_back(c.mutation_count)
	
	return conf

# TODO: Ajusts the setup of the menu
sync func set_setup(s):
	var conf = s.config

# Gets called when the player count selectors value is set
func change_player_count():
	# We are busy setting up children, so we schedule the call for idle time
	call_deferred("change_player_count_deferred")

# Changes the player count and the associated buttons
func change_player_count_deferred():
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
# 1 means two-player compete
func set_player_count(mode):
	var button = preload("res://Scenes/Menus/MenuEntries/button.scn")
	
	# Set the player count according to the mode
	player_count = 1
	if mode == 1:
		player_count = 2
	
	while config_menus.size() <= player_count:
		var menu = preload("res://Scenes/Menus/Submenus/config_menu.scn").instance()
		config_menus.push_back( menu )
		menu.set_scheme("default " + str(config_menus.size()))
	
	# Set the config menu buttons
	for i in range(player_count):
		var player_conf = button.instance()
		player_conf.set_text("player " + str(i + 1))
		player_conf.set_name("p" + str(i + 1) + "config")
		config_buttons.push_back(player_conf)
		
		var index = get_node("player_count").get_index() + 1 + i
		add_child(player_conf)
		move_child(player_conf, index)
		
		player_conf.connect("pressed", self, "open_player_config", [i])

# Open the player config of a certain player
func open_player_config(index):
	var config = config_menus[index]
	
	config.index = index
	config.game_menu = self
	
	top_menu.set_active_menu(config)
	delete_player_buttons()

# Activates the leaderboard
func activate_leaderboard():
	var leaderboard = preload("res://Scenes/Menus/Submenus/leaderboard.scn").instance()
	top_menu.set_active_menu(leaderboard)
	leaderboard.set_config( get_config() )

# Sets wether this menu is for an online or an offline game
func set_online(is_online):
	get_node("start").set_hidden(is_online)
