tool
extends Container

signal focus(entry)
signal pressed

export(String) var text setget set_text

var x_pos = 0
var min_x_pos = -256+64
var max_x_pos = 256-64

var is_moving = false
var move_from
var value

var is_focussed = false

var square_target_opacity = 0.4
var label_target_opacity = 1.0

func _ready():
	apply_size()
	set_x_pos(4)
	set_text(text)
	
	set_process(true)

func _process(delta):
	go_to_square_opacity(delta)
	go_to_label_opacity(delta)
	
	var menu = get_node("/root/global").menu
	
	if not menu == null and menu.get_active_entry() == self:
		square_target_opacity = 1
		label_target_opacity = 0
	else:
		square_target_opacity = 0.4
		label_target_opacity = 1

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			move_from = event.x - x_pos
			is_moving = true
		else:
			is_moving = false
	
	if event.type == InputEvent.MOUSE_MOTION:
		emit_signal("focus", self)
		set_process(true)
		
		if is_moving:
			set_x_pos(event.x - move_from)
	
	if event.is_action("left"):
		set_x_pos(x_pos - 10)
	if event.is_action("right"):
		set_x_pos(x_pos + 10)

func press():
	emit_signal("pressed")

# Sets the text
func set_text(t):
	text = t
	var label = get_node("label")
	if not label == null:
		label.set_text(t)

# applies the size to the size indicator
func apply_size():
	get_node("container").set_pos(get_size()/2.0)
	get_node("container").set_size(Vector2(512 - 64, 64) + 1 * Vector2(1, 1))

# Sets the opacity of the square
func go_to_square_opacity(delta):
	var prev_opacity = get_node("container/square").get_opacity()
	var next_opacity = get_node("/root/global").go_to(square_target_opacity, prev_opacity, delta * 0.5)
	get_node("container/square").set_opacity(next_opacity)

# Sets the opacity of the label
func go_to_label_opacity(delta):
	var prev_opacity = get_node("label").get_opacity()
	var next_opacity = get_node("/root/global").go_to(label_target_opacity, prev_opacity, delta * 0.5)
	get_node("label").set_opacity(next_opacity)

# Sets how far the slider has slided
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
