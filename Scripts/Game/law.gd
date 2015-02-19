
extends Node2D

var rules = []

func _ready():
	# Initialization here
	
	var rule_template = load("Scenes/Game/forbidden.scn")
	for i in range (0, 3):
		var new_rule = rule_template.instance()
		add_child(new_rule)
		new_rule.set_pos(Vector2(0, 128*i))
		rules.append(new_rule)
	
	pass

func police():
	# TODO check if everything in the grid is legal
	
	
	
	pass
