extends Animation

func _ready():
	initialize(10, 20, 10)
	
	set_input_values([1.0, 2.0])
	print( get_output_values().size() )
	#initialize(1, 2, 3)
	#set_input(0, 10.0)
	#compute()

func _computation_event(ev):
	print("afdsa")
