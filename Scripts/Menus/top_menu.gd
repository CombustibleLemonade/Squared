extends "submenu.gd"

var menu_stack = [self]

func _ready():
	top_menu = self
	
	index_in_parent = 0
	
	set_process_input(true)
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
	
	get_active_menu().active_entry_index = -selector.target
	
	menu.top_menu = self
	menu.set_size_in_menu()
	
	add_child(menu)
	menu_stack.push_back(menu)
	
	# Set the target
	on_menu_changed()
	selector.set_target(0)

# Pops the active menu
func pop_active_menu():
	remove_child(menu_stack[menu_stack.size()-1])
	
	menu_stack.remove(menu_stack.size()-1)
	
	add_child(menu_stack[menu_stack.size()-1])
	on_menu_changed()
	
	selector.target = -get_active_menu().active_entry_index

func on_menu_changed():
	main.scroll = 0
	main.set_options()

# Returns the active menu
func get_active_menu():
	return menu_stack[menu_stack.size()-1]
