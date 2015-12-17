extends Container

# TODO

var selector
var size = 0

func _init():
	set_process(true)
	
	selector = get_node("/root/main/selector")

func _process(delta):
	set_size()

func set_size():
	size = get_child_count()
	set_custom_minimum_size(Vector2(0, 63))

func press():
	get_position_in_parent()