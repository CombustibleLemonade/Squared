extends Sprite

# member variables here, example:

var target = 0

func move(dx):
	# Will move (Positive is up, negative is down)
	target += dx
	
	if target < 0:
		target = 0
	elif target > 8:
		target = 8
	
	pass

func _ready():
	# Initalization here
	set_process(true)
	set_process_input(true)
	pass

func _input(ev):
	# To handle input
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo:
		if ev.is_action("up"):
			move(1)
		elif ev.is_action("down"):
			move(-1)
	
	pass

func _process(delta):
	# Will make the selector move to the target position
	var deltavector = Vector2(0, -64*(target-4)) - get_pos()
	
	set_pos(get_pos() + deltavector*25*delta)
	
	pass
