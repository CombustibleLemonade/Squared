extends "submenu.gd"

onready var input = get_node("/root/input")
var scheme = "" setget set_scheme
var binding

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

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

func on_key_change(b):
	input.add_binding(scheme,b.text,b.key_event)
	input.save_scheme()
