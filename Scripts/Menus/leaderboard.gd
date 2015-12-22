extends "submenu.gd"
var s

# Gets all highscores of config c
func set_config(c):
	s = get_node("/root/global").get_scores_of_config(c)
	
	for i in range(s.size()):
		var b = preload("res://Scenes/Menus/MenuEntries/button.scn").instance()
		b.set_name(str(i))
		b.set_text(str(s[i]))
		add_child(b)

# Returns to the game menu
func back():
	top_menu.pop_active_menu()
