extends Node2D

signal moved(to)

var target = 0

var min_y = 0
var max_y = 7

var offset = 0
var size_set = false

func _ready():
	set_active(true)
	if not size_set:
		set_size(Vector2(64*get_node("/root/global").width, 64))

func _input(ev):
	# Move up and down
	var parent = get_parent()
	if ev.type == InputEvent.KEY and ev.is_pressed() and not ev.echo:
		if ev.is_action("up"):
			move(1)
			if target - parent.get_focus() > 6:
				parent.set_focus(target-6)
		elif ev.is_action("down"):
			move(-1)
			if target - parent.get_focus() < 0:
				parent.set_focus(target)

func _process(delta):
	# Will make the selector move to the target position
	var target_vec = Vector2(0, -64*(target + offset))
	set_pos(get_node("/root/global").go_to(target_vec, get_pos(), delta))

# Will move (Positive is up, negative is down)
func move(dy):
	target = clamp(target + dy, min_y, max_y)
	
	emit_signal("moved", target)

# Will move to an absolute position
func set_target(var y):
	target = y
	move(0)

# Will set the size of the polygon, with rounded corners
func set_size(var size):
	get_node("Polygon").set_size(size)
	size_set = true

func set_active(var is_active):
	set_process(is_active)
	set_process_input(is_active)
