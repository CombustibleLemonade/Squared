extends "submenu.gd"

onready var input = get_node("/root/input")
var s

func _ready():
	if s == null:
		s = get_schemes()
	else:
		return
	
	for i in range(s.size()):
		var b = preload("res://Scenes/Menus/MenuEntries/button.scn").instance()
		b.set_name( str(i) )
		b.set_text( s[i] )
		
		add_child(b)
		move_child(b, b.get_index() - 1)
		
		b.connect("focus", self, "set_active_entry")
		b.connect("pressed", self, "pressed", [b])

func pressed(e):
	if e.get_name() == "add_scheme":
		top_menu.load_active_menu("res://Scenes/Menus/Submenus/add_scheme_menu.scn")
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name().is_valid_integer():
		top_menu.load_active_menu("res://Scenes/Menus/Submenus/control_scheme_menu.scn")
		top_menu.get_active_menu().scheme = s[int(e.get_name())]

# Returns the names of the control schemes
func get_schemes():
	return input.schemes