extends Node

var selector
var global

var menu_stack = []

var background_offset = 16

func _ready():
	selector = get_node("selector")
	global = get_node("/root/global")
	
	set_process(true)
	set_process_input(true)
	global.menu = self
	
	# OS.set_window_fullscreen(true)
	
	set_active_menu(get_node("menu"))
	get_node("background").set_process_input(false)
	get_node("background").offset = 0
	get_node("background/Polygon").set_color(Color(0.3, 0.3, 0.3, 0.9))
	
	set_options()

func _process(delta):
	set_pos(OS.get_video_mode_size()/2)
	var scale = OS.get_video_mode_size().y/600
	set_scale(Vector2(scale, scale))
	
	set_options()

func _input(event):
	if global.is_playing:
		return
	
	var ae = get_active_entry()
	if not event.type in [InputEvent.MOUSE_BUTTON, InputEvent.MOUSE_MOTION] and ae.has_method("_input_event"):
		ae._input_event(event)
	
	if event.is_action_pressed("ui_up"):
		get_node("selector").move(1)
	if event.is_action_pressed("ui_down"):
		get_node("selector").move(-1)
	
	if event.is_action_pressed("ui_accept"):
		get_active_entry().press()
	
	if ae.has_method("_input"):
		ae.input(event)

# Pauses the game
func pause():
	get_tree().set_pause(true)
	set_process_input(true)
	
	get_node("menu").load_active_menu("res://Scenes/Menus/Submenus/main_menu.scn")
	
	set_options()
	
	get_node("selector").show()
	get_node("selector").set_process(true)
	get_node("selector").set_target(0)
	
	global.is_playing = false

# Unpauses the game
func unpause():
	get_tree().set_pause(false)
	set_process_input(false)

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
		target += submenu.index_in_parent
		submenu = submenu.get_parent()
	
	get_node("selector").set_target(-target)

# Sets the active entry based on index
func set_active_entry_index(var entry):
	get_node("menu").set_active_entry_index(-entry)

# Gets the selected (active) entry in the menu
func get_active_entry():
	return get_entry(-selector.target)

# Gets the i-th element of the menu
func get_entry(k):
	return menu_stack[menu_stack.size()-1].get_entry(k)

# Will position the selector to the right location for the amount of options
func set_options():
	var amount_of_options = global.get_horizontal_entry_count(menu_stack[menu_stack.size()-1])
	selector.set_process(true)
	set_size(amount_of_options)

# Will position everything to the right location for size s
func set_size(s):
	selector.max_y = 0
	selector.min_y = -s + 1
	selector.offset = (s - 1)/2.0
	
	get_node("background").set_size(Vector2(64*7 + background_offset, s*64 + background_offset))