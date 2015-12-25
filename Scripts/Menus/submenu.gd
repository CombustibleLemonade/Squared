extends Container

signal size_change(new_size)

var global
var main
var selector
var top_menu

var size = 0
var active_entry_index = 0

var index_in_parent = 0

var Configuration = load("res://Scripts/global.gd").Configuration

func _ready():
	set_process(true)

func _enter_tree():
	global = get_node("/root/global")
	main = get_node("/root/main")
	selector = get_node("/root/main/selector")
	
	for i in get_children():
		if i.has_user_signal("size_change"):
			i.connect("size_change", self, "size_change")
		i.connect("pressed", self, "pressed", [i])
		i.connect("focus", self, "set_active_entry")
	
	for i in get_parent().get_children():
		if i == self:
			break
		if i.get_name().find("@") == -1:
			index_in_parent += 1

func _process(delta):
	set_size_in_menu()

func press():
	var ae = get_active_entry()
	if ae.has_method("press"):
		get_active_entry().press()

# Called when the size changes
func size_change(s):
	emit_signal("size_change", s)

# Gets the active entry
func get_active_entry():
	return get_entry(active_entry_index)

# Gets the i-the entry of this menu
func get_entry(i):
	var active_entry
	
	var children = get_children()
	var j = 0
	var child_index = 0
	
	# Cycle to entries, substract size each time
	while j <= i:
		var child = children[child_index]
		
		# Check if child extends submenu
		# We can't use extends here, since it will lead to cyclic preloads
		if child.has_method("get_entry"):
			if child.size > i - j:
				return children[child_index].get_entry(i-j)
			
			j += children[child_index].size
		elif child extends Control and not child.get_name().begins_with("@"):
			j += 1
		
		child_index += 1
		
	
	active_entry = get_child(child_index - 1)
	return active_entry

# Sets the active entry index
func set_active_entry_index(i):
	# TODO allow for submenus
	active_entry_index = i

# Sets the active entry
func set_active_entry(entry):
	main.set_active_entry(entry)

# Gets the width that is set
func get_width():
	return get_node("width").value

# Gets the height that is set
func get_height():
	return get_node("height").value

# Sets the custom minimum size of container according to menu entries
func set_size_in_menu():
	size = 0
	for i in get_children():
		if i.has_method("get_entry"):
			size += i.size
		else:
			size += 1
	
	set_custom_minimum_size(Vector2(0, size * 64 - 1))
