extends Path2D

onready var base_follow = $Follow
onready var base_sprite = $Base
onready var follow_container = $Follow_Container
export var max_count = 5
var current_count = 0
var sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	create_follow_child(true)
	pass # Replace with function body.

func _process(delta):
#	$Follow.unit_offset += 0.001
	for i in get_children():
		if i.is_in_group("FOLLOWS") && i.is_in_group("LEADER"):
			i.offset += 1
#			prints(i.offset, int(i.offset) % 50 == 0)
			if int(i.offset) % 50 == 0:
				create_follow_child(false)
		elif i.is_in_group("FOLLOWS"):
			i.offset += 1
	pass

func _on_Button_pressed():
	set_process(!is_processing())
	pass # Replace with function body.

func create_follow_child(is_leader):
	if current_count < max_count:
		var sprite = base_sprite.duplicate(8)	
		var follow = base_follow.duplicate(8)
		follow.add_child(sprite)
		follow.add_to_group("FOLLOWS")
		if is_leader:
			follow.add_to_group("LEADER")
		add_child(follow)
		current_count += 1