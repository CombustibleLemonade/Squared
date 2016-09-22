extends "submenu.gd"

onready var options = get_node("/root/options")

func _ready():
	get_node("fullscreen").set(options.get_fullscreen())
	get_node("glow_amount").set_interval(options.get_glow())

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

func set_fullscreen(is_fullscreen):
	options.set_fullscreen(is_fullscreen)

func _on_glow_amount_x_pos_change( to ):
	if options:
		options.set_glow(to)
