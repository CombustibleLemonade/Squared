extends "submenu.gd"

var menu_stack = [self]

func _ready():
	top_menu = self
	
	index_in_parent = 0
	
	menu_stack.push_back(get_node("main_menu"))

# Load a menu and set it as active
func load_active_menu(var path):
	if path == null:
		set_active_menu(null)
		return
	
	var menu = load(path).instance()
	set_active_menu(menu)

# Set the active menu as menu
func set_active_menu(var menu):
	for i in get_children():
		if i.has_method("get_entry"):
			remove_child(i)
	
	if menu == null:
		return
	
	menu.top_menu = self
	menu.set_size()
	
	add_child(menu)
	menu_stack.push_back(menu)
	
	if menu.get_minimum_size().y < get_size().y:
		print("panic")
	
	# Set the target
	main.set_options()
	selector.set_target(0)

func pop_active_menu():
	remove_child(menu_stack[menu_stack.size()-1])
	
	menu_stack.remove(menu_stack.size()-1)
	
	add_child(menu_stack[menu_stack.size()-1])
	main.set_options()
	
	selector.target = 0