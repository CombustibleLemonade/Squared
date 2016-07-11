extends Node

var selector
var global

var menu_stack = []

var background_offset = 16
var scroll = 0

var target_pos = Vector2()
var games = []

func _ready():
	selector = get_node("selector")
	global = get_node("/root/global")
	
	set_process(true)
	set_process_input(true)
	global.menu = self
	
	set_active_menu(get_node("menu"))
	get_node("background").set_process_input(false)
	get_node("background").offset = 0
	get_node("background/Polygon").set_color(Color(0.3, 0.3, 0.3, 0.9))
	
	set_options()
	
	if OS.get_name() == "HTML5":
		get_node("menu/main_menu/credits").hide()
		get_node("menu/main_menu/quit").hide()
		
		var inp = get_node("/root/input")
		if inp.bindings.has("default 1") && inp.bindings["default 1"].has("next"):
			inp.add_binding("default 1", "next", key_event(KEY_SPACE))

func _process(delta):
	var scale = OS.get_video_mode_size().y/600
	set_scale(Vector2(scale, scale))
	
	set_options()
	
	# Move to the target position
	var next_pos = global.go_to(target_pos, get_pos(), delta)
	
	set_pos(next_pos)

func _input(event):
	if global.is_playing:
		return
	
	var ae = get_active_entry()
	if not event.type in [InputEvent.MOUSE_BUTTON, InputEvent.MOUSE_MOTION] and ae.has_method("_input_event"):
		ae._input_event(event)
	
	if is_entry_locked:
		return
	
	if event.is_action_pressed("ui_up"):
		get_active_entry().on_defocus()
		get_node("selector").move(1)
		get_active_entry().on_focus()
	
	if event.is_action_pressed("ui_down"):
		get_active_entry().on_defocus()
		get_node("selector").move(-1)
		get_active_entry().on_focus()
	
	if event.is_action_pressed("ui_accept"):
		get_active_entry().press()
	
	if event.is_action_pressed("ui_cancel") and get_tree().is_paused():
		unpause()
	
	if ae.has_method("_input"):
		ae.input(event)

# Pauses the game
func pause():
	get_tree().set_pause(true)
	set_process_input(true)
	
	# get_node("menu").load_active_menu("res://Scenes/Menus/Submenus/main_menu.scn")
	get_node("menu").show()
	get_node("background").show()
	
	set_options()
	
	get_node("selector").show()
	get_node("selector").set_process(true)
	get_node("selector").set_target(0)
	
	global.is_playing = false

# Unpauses the game
func unpause():
	# If there is no unpausable game, return
	if has_node("game") and get_node("game").died:
		return
	
	if has_node("replayer") and get_node("replayer/game").died:
		return
	
	var game
	if has_node("replayer"):
		game = get_node("replayer/game")
	if has_node("game"):
		game = get_node("game")
	
	get_tree().set_pause(false)
	set_process_input(false)
	
	get_node("menu").hide()
	get_node("background").hide()
	
	get_node("selector").hide()
	get_node("selector").set_process(false)
	
	global.is_playing = true
	
	if not game == null:
		game.activate()

# Sets the active menu
func set_active_menu(var menu):
	get_node("background").show()
	
	if not menu_stack.size() == 0:
		menu_stack[menu_stack.size()-1].hide()
		menu_stack[menu_stack.size()-1].set_process(false)
	menu_stack.push_back(menu)
	menu_stack[menu_stack.size()-1].show()
	menu_stack[menu_stack.size()-1].set_process_input(true)
	menu_stack[menu_stack.size()-1].grab_focus()
	
	set_options()
	
	selector.set_target(0)

var is_entry_locked = false

func set_menu_lock(is_locked):
	is_entry_locked = is_locked

# Sets the selected (active) entry in the menu
func set_active_entry(var entry):
	if is_entry_locked:
		return
	
	if entry != get_active_entry():
		get_active_entry().on_defocus()
		entry.on_focus()
	
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
		target += submenu.index_in_parent
		submenu = submenu.get_parent()
	
	selector.set_target(-target)

# Gets the selected (active) entry in the menu
func get_active_entry():
	return get_entry(-selector.target)

# Gets the i-th element of the menu
func get_entry(k):
	return menu_stack[menu_stack.size()-1].get_entry(k)

# Will position the selector to the right location for the amount of options
func set_options():
	var amount_of_options = global.get_vertical_entry_count(menu_stack[menu_stack.size()-1])
	selector.set_process(true)
	set_size(amount_of_options)

# Will position everything to the right location for size s
func set_size(s):
	selector.max_y = 0
	selector.min_y = -s + 1
	selector.offset = (s - 1)/2.0
	
	var size = Vector2(64*7 + background_offset, s*64 + background_offset)
	
	get_node("background").set_size(size)
	get_node("menu").get_active_menu().center()
	
	set_scroll()

# Sets the scrolling
func set_scroll():
	var selector_deviation = 64 * (selector.target + selector.offset) - scroll
	
	if selector_deviation > 256:
		scroll += 64
	if selector_deviation < -256:
		scroll -= 64
	
	target_pos = Vector2(OS.get_window_size().x / 2, OS.get_window_size().y * (0.5 + scroll / 600.0))
