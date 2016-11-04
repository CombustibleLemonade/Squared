extends "submenu.gd"

onready var options = get_node("/root/options")

func _ready():
	var opt = get_node("/root/options").options
	get_node("master").set_interval(opt["audio_master"])

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

# Gets called when the slider is set
func on_master_set( to ):
	if (options):
		get_node("/root/audio" ).set_master_volume(to)
