extends Polygon2D

var offset = 9
var rectangle_size

var left_top = [Vector2(0, -offset), Vector2(offset, 0)]
var right_top = [Vector2(-offset, 0), Vector2(0, -offset)]
var right_bottom = [Vector2(0, offset), Vector2(-offset, 0)]
var left_bottom = [Vector2(offset, 0), Vector2(0, offset)]

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

func _draw():
	draw_circle(Vector2(rectangle_size.x, rectangle_size.y)/2 + Vector2(-offset, -offset), offset, get_color())
	draw_circle(Vector2(-rectangle_size.x, rectangle_size.y)/2 + Vector2(offset, -offset), offset, get_color())
	draw_circle(Vector2(rectangle_size.x, -rectangle_size.y)/2 + Vector2(-offset, offset), offset, get_color())
	draw_circle(Vector2(-rectangle_size.x, -rectangle_size.y)/2 + Vector2(offset, offset), offset, get_color())
	pass

func _ready():
	var x = self
	while (x.has_method("get_opacity()")):
		print(x.get_opacity())
	pass
