extends Node2D

# Nodes we have
var selector
var global
var active_menu # Changes according to which (sub)menu is displayed

var background_offset = 16

func _ready():
	print(range(-1, -1, -1))
	
	set_process_input(true)
	set_process(true)
	
	OS.set_window_fullscreen(true)
	
	# Define nodes
	selector = get_node("selector")
	global = get_node("/root/global")
	
	selector.set_process_input(false)
	set_active_menu(get_node("main_menu"))
	
	get_node("background").set_process_input(false)
	get_node("background").offset = 0
	get_node("background/Polygon").set_color(Color(0.3, 0.3, 0.3, 0.9))
	
	global.menu = self

func _process(delta):
	set_pos(OS.get_video_mode_size()/2)
	var scale = OS.get_video_mode_size().y/600
	set_scale(Vector2(scale, scale))
	
	get_node("game_menu/config").apply_highscore()

# Handles input events
func _input(event):
	var ae = get_active_entry()
	if event.type == InputEvent.KEY and not ae == null and ae.has_method("_input_event"):
		ae._input_event(event)
	
	ae = get_active_entry()
	
	# Prevent double-pressing buttons
	if global.menu_change:
		global.menu_change = false
		return
	
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		var game = get_node("game")
		if active_menu == get_node("main_menu") and not game == null and not game.died:
			unpause()
			return
		if active_menu == get_node("options_menu"): 
			options_menu_back()
	
	# Code to do things according to button pressed
	if event.is_action_pressed("ui_accept") and ae.has_method("press"):
		ae.press()
	
	# Moving up and down
	if event.is_action_pressed("ui_up"):
		selector.move(1)
	if event.is_action_pressed("ui_down"):
		selector.move(-1)

# Will hide the menu and start the game
func start_game():
	if has_node("game"): # remove the previous game
		get_node("game").free()
	
	if has_node("squares"):
		get_node("squares").free()
	
	get_tree().set_pause(false) # unpause the game
	
	var game = preload("../Scenes/Game/game.scn").instance()
	game.width = global.width
	game.height = global.height
	
	
	var config = get_node("game_menu/config").get_config()
	game.set_config(config)
	game.drop_time = get_node("game_menu/drop_time").value
	
	add_child(game)
	
	var scores = global.get_scores_of_config(config)
	
	unpause()

func activate_game_menu():
	set_active_menu(get_node("game_menu"))

func activate_options_menu():
	set_active_menu(get_node("options_menu"))

func options_menu_back():
	set_active_menu(get_node("main_menu"))
	selector.set_target(-get_node("main_menu/options").get_position_in_parent())

func activate_credits_menu():
	set_active_menu(get_node("credits_menu"))
	pass

# These functions open links for the credits
func store_page():
	OS.shell_open("http://combustible-lemonade.itch.io/squared")
func artist():
	OS.shell_open("https://soundcloud.com/unfa")
func font():
	OS.shell_open("http://www.dafont.com/accuratist.font")

func credits_menu_back():
	set_active_menu(get_node("main_menu"))
	selector.set_target(-get_node("main_menu/credits").get_position_in_parent())

func activate_graphics_menu():
	set_active_menu(get_node("graphics_menu"))
	global.menu_change = true # The script to handle input changes

func activate_gameplay_menu():
	set_active_menu(get_node("gameplay_menu"))
	global.menu_change = true # The script to handle input changes

# quits the game
func quit():
	get_tree().quit()

# Will un-hide all main menu items
func pause(var message = "paused"):
	set_active_menu(get_node("main_menu"))
	selector.show()
	global.is_playing = false # We're not playing anymore

# Will hide all main menu items and resume playing
func unpause():
	get_tree().set_pause(false)
	active_menu.hide()
	selector.hide()
	get_node("background").hide()
	
	set_process_input(false)
	global.is_playing = true

# Sets the active menu
func set_active_menu(var menu):
	get_node("background").show()
	
	if not active_menu == null:
		active_menu.hide()
		active_menu.set_process_input(false)
	active_menu = menu
	active_menu.show()
	active_menu.set_process_input(true)
	active_menu.grab_focus()
	
	set_options()
	selector.set_target(0)
	set_process_input(true)

# Sets the selected (active) entry in the menu
func set_active_entry(var entry):
	if not entry.get("is_focussed") == null:
		entry.is_focussed = true
	
	var previous_entry = get_active_entry()
	if not previous_entry.get("is_focussed") == null:
		previous_entry.is_focussed = false
	
	var target = 0
	var submenu = entry.get_parent()
	
	var i = 0
	while not submenu.get_child(i) == entry:
		var size = submenu.get_child(i).get("size")
		if size == null:
			size = 1
		target += size
		i += 1
	
	while submenu extends preload("Menus/submenu.gd"):
		target += submenu.get_position_in_parent()
		submenu = submenu.get_parent()
	
	get_node("selector").set_target(-target)

# Sets the active entry based on index
func set_active_entry_index(var entry):
	var active_entry
	var children = active_menu.get_children()
	var i = 0
	var child_index = 0
	
	# Cycle to entries, substract size each time
	while i <= -selector.target:
		if children[child_index] extends preload("Menus/submenu.gd"):
			if children[child_index].size >= entry - i:
				# If our selected entry is a submenu, set its entry
				return children[child_index].set_entry_index( - i - entry )
			
			i += children[child_index].size
		if children[child_index] extends Control:
			i += 1
		else:
			break
		child_index += 1

# Gets the selected (active) entry in the menu
func get_active_entry():
	return get_entry(-selector.target)

# Gets the i-th element of the menu
func get_entry(k):
	var active_entry
	
	var children = active_menu.get_children()
	var i = 0
	var child_index = 0
	
	# Cycle to entries, substract size each time
	while i <= k:
		if children[child_index] extends preload("Menus/submenu.gd"):
			if children[child_index].size > k - i:
				return children[child_index]
			
			i += children[child_index].size
		elif children[child_index] extends Control:
			i += 1
		else:
			break
		child_index += 1
	
	active_entry = active_menu.get_child(child_index - 1)
	return active_entry

# Will position the selector to the right location for the amount of options
func set_options():
	var amount_of_options = global.get_horizontal_entry_count(active_menu)
	selector.max_y = 0
	selector.min_y = -amount_of_options + 1
	selector.offset = (amount_of_options - 1)/2.0
	
	get_node("background").set_size(Vector2(64*7 + background_offset, amount_of_options*64 + background_offset))

# Gets called when the slider for the drop time changes
func drop_time_x_pos_change(x_pos):
	var value = tan((x_pos * 0.48 + 0.005) * PI) * 4
	
	if x_pos == 1:
		value = "inf"
	
	get_node("game_menu/drop_time").value = value
