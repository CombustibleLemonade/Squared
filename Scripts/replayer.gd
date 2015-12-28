extends Node2D

func _ready():
	get_node("game").set_process_input(false)
	start()

func start():
	set_process(true)

func pause():
	pass
