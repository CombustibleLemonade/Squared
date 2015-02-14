
extends Node2D

# member variables here, example:

func _ready():
	# Initalization here
	print(get_node("Arrow").set_modulate(Color(1, 1, 1, 0.3)))
	
	set_pos(Vector2(0,0))
	
	pass

func set_modulate(color):
	# Change the color of the indicator
	color[3] = 0.3
	get_node("Arrow").set_modulate(color)
	
	pass
