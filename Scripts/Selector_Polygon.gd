extends Polygon2D

var offset = 9
var resolution = 20 # amount of edges in the rounded corners
var rectangle_size

# Define polygon for the selector
var left_top = left_top()
var right_top = right_top()
var right_bottom = right_bottom()
var left_bottom = left_bottom()

func set_arrays():
	left_top = left_top()
	right_top = right_top()
	right_bottom = right_bottom()
	left_bottom = left_bottom()

func left_top():
	var return_val = []
	for i in range(0, resolution):
		var s = (PI/2)*i/resolution
		return_val.push_back(Vector2(offset*(-cos(s)+1), -offset*(-sin(s)+1)))
	return_val.push_back(Vector2(offset, 0))
	return return_val

func right_top():
	var return_val = []
	for i in range(0, resolution):
		var s = (PI/2)*i/resolution
		return_val.push_back(Vector2(offset*(sin(s)-1), offset*(cos(s)-1)))
	return_val.push_back(Vector2(0, -offset))
	return return_val

func right_bottom():
	var return_val = []
	for i in range(0, resolution):
		var s = (PI/2)*i/resolution
		return_val.push_back(Vector2(-offset*(-cos(s)+1), offset*(-sin(s)+1)))
	return_val.push_back(Vector2(-offset, 0))
	return return_val

func left_bottom():
	var return_val = []
	for i in range(0, resolution):
		var s = (PI/2)*i/resolution
		return_val.push_back(Vector2(-offset*(sin(s)-1), -offset*(cos(s)-1)))
	return_val.push_back(Vector2(0, offset))
	return return_val

func set_size(var size):
	var polygon = []
	
	for i in left_top:
		polygon.push_back(i + Vector2(-size.x, size.y)/2)
	
	for i in right_top:
		polygon.push_back(i + size/2)
	
	for i in right_bottom:
		polygon.push_back(i + Vector2(size.x, -size.y)/2)
	
	for i in left_bottom:
		polygon.push_back(i - size/2)
	
	set_polygon(polygon)
	
	rectangle_size = size
	update()
	pass
