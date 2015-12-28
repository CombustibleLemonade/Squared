extends "submenu.gd"

var record

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "replay":
		start_replay()

func start_replay():
	print("asdf")
