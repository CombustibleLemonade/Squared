extends "submenu.gd"

onready var networking = get_node("/root/networking")

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "connect":
		connect()

# Connects to an ip to join the game
func connect():
	var ip = get_node("ip").get_text()
	
	top_menu.load_active_menu("res://Scenes/Menus/Submenus/game_menu.scn")
	
	networking.join(ip)
	networking.connect("start_game", self, "start_game")


# Gets called when the game starts
func start_game(setup):
	print("WE STARTED!")
