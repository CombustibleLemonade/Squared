extends "submenu.gd"

func _ready():
	get_node("version").set_text(get_node("/root/global").version)

func pressed(e):
	if e.get_name() == "store_page":
		OS.shell_open("http://combustible-lemonade.itch.io/squared")
	if e.get_name() == "artist":
		OS.shell_open("https://soundcloud.com/unfa")
	if e.get_name() == "font":
		OS.shell_open("http://www.dafont.com/accuratist.font")
	if e.get_name() == "back":
		top_menu.pop_active_menu()
