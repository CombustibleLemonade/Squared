extends "submenu.gd"

onready var input = get_node("/root/input")
var scheme = "" setget set_scheme
var binding

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()
	if e.get_name() == "delete_final":
		top_menu.pop_active_menu()
		delete_scheme()
	if e.get_name() == "delete":
		e.set_name("delete_final")
		e.set_text("are you sure?")


func set_scheme(s):
	scheme = s
	if binding == null:
		binding = input.bindings[s]
		add_binding_entries()

func add_binding_entries():
	for i in input.controls:
		var b = preload("res://Scenes/Menus/MenuEntries/key_binder.scn").instance()
		
		add_child(b)
		
		b.text = i
		b.set_key_event(binding[i])
		b.set_name( i )
		
		b.connect("focus", self, "set_active_entry")
		b.connect("pressed", self, "pressed", [b])
		b.connect("key_set", self, "on_key_change", [b])

# Gets called when a key is reset
func on_key_change(b):
	input.add_binding(scheme, b.text, b.key_event)
	input.save_scheme()

# Deletes a control scheme
func delete_scheme():
	input.remove_control_scheme(scheme)
	get_scheme_button(top_menu.get_active_menu()).queue_free()

# Returns the menu button that corresponds with this scheme
func get_scheme_button(menu):
	var children = menu.get_children()
	for c in children:
		if c.get_text() == scheme:
			return c
