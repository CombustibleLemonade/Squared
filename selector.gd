
extends Sprite

# member variables here, example:

var target = 4

func move(dx):
	
	target -= dx
	
	if target < 0:
		target = 0
	elif target > 8:
		target = 8
	
	pass

func _ready():
	# Initalization here
	
	set_process(true)
	pass

func _process(delta):
	
	var position = get_pos()
	var deltavector = Vector2(0, 64*(target-4)) - position
	
	set_pos(position + deltavector*0.5)
	
	pass
