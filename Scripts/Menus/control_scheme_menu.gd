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
	for i in range(binding.size()):
		var name = OS.get_scancode_string(binding[i].scancode)
		var b = preload("res://Scenes/Menus/MenuEntries/key_binder.scn").instance()
		
		add_child(b)
		
		b.text = "asdf"
		b.key = name
		b.set_name( str(i) )
		
		b.connect("focus", self, "set_active_entry")
		b.connect("pressed", self, "pressed", [b])
