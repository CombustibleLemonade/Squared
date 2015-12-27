extends "submenu.gd"

var s
var config

# Gets all highscores of config c
func set_config(c):
	config = c
	s = get_node("/root/global").get_scores_of_config(c)
	
	for i in range(s.size()):
		var b = preload("res://Scenes/Menus/MenuEntries/button.scn").instance()
		b.set_name(str(i))
		b.set_text(str(s[i]))
		add_child(b)
		
		b.connect("focus", self, "set_active_entry")

# Returns to the game menu
func back():
	top_menu.pop_active_menu()

func pressed(e):
	if e.get_name() == "reset":
		global.reset_scores_of_config(config)
		for i in get_children():
			if i.get_name().is_valid_integer():
				remove_child(i)
				i.queue_free()
	if e.get_name() == "back":
		top_menu.pop_active_menu()