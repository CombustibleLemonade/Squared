extends VBoxContainer

var global

func _ready():
	global = get_node("/root/global")
	
	get_node("fullscreen").is_on = OS.is_video_mode_fullscreen()
	pass

func _input(event):
	# prevent double presses
	if global.menu_change:
		get_node("fullscreen").is_on = OS.is_window_fullscreen()
		global.menu_change = false
		return
	
	if is_hidden():
		return
	
	if not event.is_pressed():
		return
	
	var selected = get_parent().get_selected()
	
	if event.is_action("ui_cancel"):
		exit()
		return
	
	if event.is_action("ui_accept") and not event.is_echo():
		if selected == "fullscreen":
			get_node("fullscreen").toggle()
		if selected == "accept":
			accept()
			exit()
			return
		if selected == "cancel":
			exit()
			return
		
	pass

# Will activate settings changes and exit
func accept():
	if not get_node("fullscreen").is_on == OS.is_window_fullscreen():
		OS.set_window_fullscreen(get_node("fullscreen").is_on)
	pass

# Will exit
func exit():
	get_parent().set_active_menu(get_parent().get_node("options_menu"))
	global.menu_change = true
	pass