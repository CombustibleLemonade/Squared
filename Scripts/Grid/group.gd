extends Node

var color = ""
var member_count = 1
var members = []
var base_member
var game

func _init(var base):
	base_member = base
	game = base.parent
	game.groups.push_back(self) # Add ourselves to the groups
	color = base_member.color
	expand()

# Make all members that should be in this group be part of this group
# Furthermore, create new groups for split off parts
func expand():
	var unchecked_members = {base_member.target_cell:base_member} # Members that are queued but have not yet been checked
	var all_members = {base_member.target_cell:base_member} # All members
	base_member.check = true # The base member is already checked, and is already in the unchecked members
	
	while not unchecked_members.empty():
		for i in unchecked_members.keys():
			var member = unchecked_members[i]
			unchecked_members.erase(i)
			if not member.group == self and not member.group == null:
				member.group.member_count -= 1
				member.group = self
			
			var n = member.neighbors_check(false)
			
			# This somehow reduces the amout of errors
			unchecked_members = merge(unchecked_members, n)
			
			for j in n.keys():
				unchecked_members[j] = n[j]
				unchecked_members[j].check = true
				unchecked_members[j].has_changed = false
				all_members[j] = n[j]
	
	for i in range (members.size()-1, -1, -1):
		if all_members.has(members[i].target_cell):
			members.remove(i)
	
	for i in members:
		if i.group == self:
			i.regroup()
	
	member_count = all_members.size()
	
	members = []
	for i in all_members.keys():
		all_members[i].check = false
		members.push_back(all_members[i])
	
	members.sort_custom(self, "sort_vertical")
	
	for i in range(members.size()):
		members[i].label.set_text(str(i+1))

func merge(a, b):
	var c = {}
	for i in a.keys():
		c[i] = a[i]
	for i in b.keys():
		c[i] = b[i]
	return c

# Function used to sort from bottom to top, then left to right
func sort_vertical(var a, var b):
	if a.target_cell.y < b.target_cell.y:
		return true
	if a.target_cell.y == b.target_cell.y and a.target_cell.x < b.target_cell.x:
		return true
	return false
