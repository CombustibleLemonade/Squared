extends "submenu.gd"

onready var input = get_node("/root/input")

func _ready():
	for i in input.controls:
		var b = preload("res://Scenes/Menus/MenuEntries/key_binder.scn").instance()
		
		add_child(b)
		
		b.set_text(i)
		b.set_name(i)
		
		move_child(b, b.get_index() - 2)
		
		b.connect("focus", self, "set_active_entry")
		b.connect("pressed", self, "pressed", [b])

func pressed(e):
	if e.get_name() == "cancel":
		top_menu.pop_active_menu()
	if e.get_name() == "accept":
		if add_scheme():
			refresh_parent_menu()

# Adds the scheme and pops the upper menu
func add_scheme():
	if get_node("line_edit").get_text() == "":
		set_active_entry(get_node("line_edit"))
		return false
	
	for i in input.controls:
		if !get_node(i).is_key_valid():
			set_active_entry(get_node(i))
			return false
	
	input.add_control_scheme(get_node("line_edit").get_text())
	for i in input.controls:
		input.add_binding(get_node("line_edit").get_text(), i, get_node(i).key_event)
	
	input.save_scheme()
	
	return true

func refresh_parent_menu():
	top_menu.pop_active_menu()
	top_menu.pop_active_menu()
	top_menu.get_active_menu().get_node("controls").press()
