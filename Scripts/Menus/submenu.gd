extends Container

signal size_change(new_size)

var global
var main
var selector
var top_menu

var size = 0
var active_entry_index = 0

var index_in_parent = 0

var Configuration = preload("res://Scripts/GlobalScope/global.gd").Configuration

func _ready():
	set_process(true)
	index_in_parent = 0 # Reset the index in parent
	
	global = get_node("/root/global")
	main = get_node("/root/main")
	selector = get_node("/root/main/selector")
	
	add_constant_override("separation", 1)
	
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
	
	# Cycle to entries, add size to j, until j equals i
	while j <= i:
		var child = children[child_index]
		
		# Check if child extends submenu
		# We can't use extends here, since it will lead to cyclic preloads
		if child.has_method("get_entry"):
			if child.size > i - j:
				return children[child_index].get_entry(i-j)
			
			j += children[child_index].size
		elif does_child_count(child):
			j += 1
		
		child_index += 1
	
	active_entry = get_child(child_index - 1)
	return active_entry

# Returns if a child counts towards the total
func does_child_count(c):
	if c extends Control and not c.get_name().begins_with("@") and not c.is_hidden():
		return true
	return false

# Sets the active entry
func set_active_entry(entry):
	main.set_active_entry(entry)

# Sets the custom minimum size of container according to menu entries
func set_size_in_menu():
	size = 0
	for i in get_children():
		if not i.get("size") == null:
			size += i.size
		else:
			size += 1
	
	set_custom_minimum_size(Vector2(0, size * 64 - 1))

# Sets the scroll of the menu
func center():
	set_pos(Vector2(0, 300 - size * 32))

# Registers a child
func register_child(c):
	if c extends Label:
		if !c.is_connected("pressed", self, "pressed"):
			c.connect("pressed", self, "pressed", [c])
	
	if !c.is_connected("focus", self, "set_active_entry"):
		c.connect("focus", self, "set_active_entry")
