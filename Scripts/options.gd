
extends VBoxContainer

func _ready():
	# Initialization here
	
	
	pass

func _on_Button_pressed():
	get_node("../SamplePlayer").play("Close")
	hide();
	get_parent().get_node("main_menu").show()
	
	pass # replace with function body

func _on_CheckBox_toggled( pressed ):
	OS.set_window_fullscreen(pressed)
	pass # replace with function body
