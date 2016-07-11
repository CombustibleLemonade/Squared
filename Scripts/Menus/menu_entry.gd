extends Control

signal pressed

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

# Called when pressed
func press():
	emit_signal("pressed")
	play_click_sound()

# Called when focus gained
func on_focus():
	play_hover_sound()

# Called when focus lost
func on_defocus():
	pass

# Called when a click sound effect needs to be played
func play_click_sound():
	pass

# Called when a hover sound effect needs to be played
func play_hover_sound():
	get_node("/root/global").sounds.play("hover")