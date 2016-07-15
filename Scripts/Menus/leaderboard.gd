extends "submenu.gd"

var s
var config

# Gets all highscores of config c
func set_config(c):
	config = c
	s = get_node("/root/highscores").get_scores_of_config(c)
	
	for i in range(s.size()):
		var b = preload("res://Scenes/Menus/MenuEntries/button.scn").instance()
		b.set_name(str(i))
		b.set_text(str(s[i].score))
		add_child(b)
		
		b.connect("focus", self, "set_active_entry")
		b.connect("pressed", self, "pressed", [b])

# Returns to the game menu
func back():
	top_menu.pop_active_menu()

func pressed(e):
	if e.get_name() == "reset":
		e.set_name("reset_sure")
		e.set_text("are you sure?")
	elif e.get_name() == "reset_sure":
		e.set_name("reset")
		e.set_text("reset")
		reset_scores()
	elif e.get_name() == "back":
		top_menu.pop_active_menu()
	elif e.get_name().is_valid_integer():
		var record = dict2inst(s[int(e.get_name())])
		top_menu.load_active_menu("res://Scenes/Menus/Submenus/record_menu.scn")
		top_menu.get_active_menu().record = record

# resets scores of this config
func reset_scores():
	global.reset_scores_of_config(config)
	for i in get_children():
		if i.get_name().is_valid_integer():
			remove_child(i)
			i.queue_free()
	
	top_menu.pop_active_menu()
