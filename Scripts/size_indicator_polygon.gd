extends "Selector_Polygon.gd"

var thickness = 2

# Creates a selection square around something
func set_size(var size):
	var polygon = []
	
	offset += thickness
	
	set_arrays()
	
	for i in left_top:
		polygon.push_back(i + Vector2(-size.x, size.y)/2)
	
	for i in right_top:
		polygon.push_back(i + size/2)
	
	for i in right_bottom:
		polygon.push_back(i + Vector2(size.x, -size.y)/2)
	
	for i in left_bottom:
		polygon.push_back(i - size/2)
	
	# Adding final connection: keep in mind set_polygon goes crazy when two points have the same coordinates
	var point1 = Vector2(-size.x, size.y)/2.0 - Vector2(0,  offset + 0.1)
	
	offset -= thickness
	size -= Vector2(thickness, thickness) * 2
	set_arrays()
	
	left_top.invert()
	right_top.invert()
	left_bottom.invert()
	right_bottom.invert()
	
	var point2 = Vector2(-size.x, size.y)/2.0 - Vector2(0,  offset + 0.1)
	polygon.push_back(point1)
	polygon.push_back(point2)
	
	for i in left_bottom:
		polygon.push_back(i - size/2)
	
	for i in right_bottom:
		polygon.push_back(i + Vector2(size.x, -size.y)/2)
	
	for i in right_top:
		polygon.push_back(i + size/2)
	
	for i in left_top:
		polygon.push_back(i + Vector2(-size.x, size.y)/2)
	
	set_polygon(polygon)
	
	rectangle_size = size
	update()
	pass
