extends Container

signal focus(entry)

var x_pos = 0
var min_x_pos = -256+64
var max_x_pos = 256-64

var is_moving = false
var move_from

func _ready():
	apply_size()
	set_x_pos(4)

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			move_from = event.x - x_pos
			is_moving = true
		else:
			is_moving = false
	
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
		
		if is_moving:
			set_x_pos(event.x - move_from)
	
	if event.is_action("left"):
		set_x_pos(x_pos - 10)
	if event.is_action("right"):
		set_x_pos(x_pos + 10)

# applies the size to the size indicator
func apply_size():
	get_node("container").set_pos(get_size()/2 + Vector2(0, 1))
	get_node("container").set_size(Vector2(512 - 64, 64) + 5 * Vector2(1, 1))

func set_x_pos(pos):
	if pos > min_x_pos and pos < max_x_pos:
		x_pos = pos
	elif pos < min_x_pos:
		x_pos = min_x_pos
	elif pos > max_x_pos:
		x_pos = max_x_pos
	get_node("container/square").set_pos(Vector2(x_pos, 0))

# returns value in range [0, 1]
func get_value():
	return ( x_pos - min_x_pos ) / ( max_x_pos - min_x_pos + 0.0 )
