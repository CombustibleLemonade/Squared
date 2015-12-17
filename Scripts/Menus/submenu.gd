extends Container

# TODO

var selector

func _input_event(event):
	selector = get_node("/root/main/selector")
	print(selector.target)

func press():
	pass