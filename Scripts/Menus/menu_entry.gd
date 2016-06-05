extends Control

var size = 1

func _enter_tree():
	if get_parent().has_method("register_child"):
		get_parent().register_child(self)
	
	if is_hidden():
		size = 0

func hide():
	.hide()
	size = 0

func show():
	.show()
	size = 1

func set_hidden(var hidden):
	.set_hidden(hidden)
	if hidden:
		size = 0
	else:
		size = 1
