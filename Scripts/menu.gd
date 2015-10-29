extends Node2D

# Nodes we have
var selector
var global
var active_menu # Changes according to which (sub)menu is displayed

func _ready():
	set_process_input(true)
	set_process(true)
	
	# Define nodes
	selector = get_node("selector")
	global = get_node("/root/global")
	
	selector.set_process_input(false)
	set_active_menu(get_node("main_menu"))
	
	pass

func _process(delta):
	set_pos(OS.get_video_mode_size()/2)
	var scale = OS.get_video_mode_size().y/600
	set_scale(Vector2(scale, scale))
	pass

# Handles input events
func _input(event):
	# Prevent double-pressing buttons
	if global.menu_change:
		global.menu_change = false
		return
	
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if active_menu == get_node("main_menu"):
			get_tree().quit()
			return
		if active_menu == get_node("options_menu"):
			options_menu_back()
	
	# Code to do things according to button pressed
	if event.is_action_pressed("ui_accept"):
		if active_menu == get_node("main_menu"):
			if get_selected() == "start":
				start_game()
			if get_selected() == "options":
				activate_options_menu()
			if get_selected() == "credits":
				activate_credits_menu()
			if get_selected() == "quit":
				get_tree().quit()
		elif active_menu == get_node("options_menu"):
			if get_selected() == "graphics":
				activate_graphics_menu()
			if get_selected() == "gameplay":
				activate_gameplay_menu()
			if get_selected() == "back":
				options_menu_back()
	
	# Moving up and down
	if event.is_action_pressed("ui_up"):
		selector.move(1)
	if event.is_action_pressed("ui_down"):
		selector.move(-1)
	pass


# Will hide the menu and start the game
func start_game():
	var game = preload("../Scenes/Game/game.scn").instance()
	game.width = global.width
	game.height = global.height
	add_child(game)
	get_node("main_menu").hide()
	selector.hide()
	set_process_input(false)
	global.is_playing = true
	pass

func activate_options_menu():
	set_active_menu(get_node("options_menu"))
	pass

func options_menu_back():
	set_active_menu(get_node("main_menu"))
	selector.set_target(-get_node("main_menu/options").get_position_in_parent())
	pass

func activate_credits_menu():
	pass

func activate_graphics_menu():
	set_active_menu(get_node("graphics_menu"))
	global.menu_change = true # The script to handle input changes
	pass

func activate_gameplay_menu():
	set_active_menu(get_node("gameplay_menu"))
	global.menu_change = true # The script to handle input changes
	pass

# Sets the active menu
func set_active_menu(var menu):
	if not active_menu == null:
		active_menu.hide()
		active_menu.set_process_input(false)
	active_menu = menu
	active_menu.show()
	active_menu.set_process_input(true)
	
	set_options()
	selector.set_target(0)
	set_process_input(true)
	pass

# Will position the selector to the right location for the amount of options
func set_options():
	var amount_of_options = active_menu.get_child_count() - 2 # Correct for 3 nodes added because it's the main node
	selector.max_y = 0
	selector.min_y = -amount_of_options + 1
	selector.offset = (amount_of_options - 1)/2.0
	pass

func get_selected():
	var object = active_menu.get_child(-selector.target)
	return object.get_text()

# Will un-hide all main menu items
func game_over(var message):
	set_active_menu(get_node("main_menu"))
	selector.show()
	pass