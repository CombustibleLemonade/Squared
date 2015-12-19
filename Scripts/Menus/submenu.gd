extends Container

var selector
var size = 0
var active_entry_index = 0
var parent

var Configuration = load("/Scripts/global.gd").Configuration

func _init():
	set_process(true)
	print("subsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsubsub")

func _process(delta):
	set_size()

func _input_event(event):
	var ae = get_active_entry()
	if ae.has_method("_input_event") and not event.type == InputEvent.MOUSE_MOTION:
		ae._input_event(event)

func press():
	var ae = get_active_entry()
	if ae.has_method("press"):
		get_active_entry().press()

# Gets the active entry
func get_active_entry():
	return get_entry(active_entry_index)

# Gets the i-the entry of this menu
func get_entry(i):
	# TODO allow for submenus in submenus
	return get_child(i)

# Sets the active entry index
func set_entry_index(i):
	# TODO allow for submenus
	active_entry_index = i

# Sets the active entry
func set_active_entry(entry):
	get_node("/root/main").set_active_entry(entry)

# Gets the width that is set
func get_width():
	return get_node("width").value

# Gets the height that is set
func get_height():
	return get_node("height").value

# Sets the custom minimum size of container according to menu entries
func set_size():
	size = get_child_count()
	set_custom_minimum_size(Vector2(0, 63))
