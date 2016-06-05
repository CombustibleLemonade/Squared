extends "submenu.gd"

func _ready():
	get_node("fullscreen").set(OS.is_window_fullscreen())

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

func set_fullscreen(is_fullscreen):
	OS.set_window_fullscreen(is_fullscreen)

func _on_glow_amount_x_pos_change( to ):
	var environment = get_node("/root/main/world_environment").get_environment()
	environment.fx_set_param(Environment.FX_PARAM_GLOW_BLUR_SCALE, to)
	environment.fx_set_param(Environment.FX_PARAM_GLOW_BLUR_STRENGTH, to * 0.4 + 0.8)
