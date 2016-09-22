extends "submenu.gd"

var index = 0 
var game_menu = null
var initialized = false

var scheme = "" setget set_scheme, get_scheme
onready var width = 7 setget set_width, get_width
onready var height = 8 setget set_height, get_height
onready var mutation_count = 4 setget set_mutation_count ,get_mutation_count

var possible_values

func _ready():
	get_node("scheme").set_possible_values(get_node("/root/input").schemes)
	get_node("scheme").set_value(get_node("scheme").get_value())
	
	initialized = true

func pressed(e):
	if e.get_name() == "back":
		top_menu.pop_active_menu()

# Sets the control scheme variable
func set_scheme(s):
	scheme = s
	
	if get_node("scheme") == null:
		return
	
	get_node("scheme").set_value( get_node("scheme").possible_values.find(s) )

# Sets the width variable
func set_width(w):
	get_node("width").value = w

# Sets the height variable
func set_height(h):
	get_node("height").value = h

# Sets the mutation count variable
func set_mutation_count(c):
	get_node("count").value = c

# Returns the control scheme variable
func get_scheme():
	return get_node("scheme").get_value_string()

# Returns the width variable
func get_width():
	return get_node("width").value

# Returns the height variable
func get_height():
	return get_node("height").value

# Returns the mutation count variable
func get_mutation_count():
	return get_node("count").value

