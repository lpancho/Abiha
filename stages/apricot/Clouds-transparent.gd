extends Node2D


var cloud_transparent_scn = load("res://stages/apricot/stage_design/Cloud-transparent.tscn")

export var speed = 120
var y_extent = 510 + (-position.y)
var children
var redraw = false

func _ready():
	enable_process(false)
	children = get_children()

func _process(delta):
	for child in children:
		var pos_y = child.position.y + speed * delta
		child.position.y = pos_y
		if pos_y > y_extent:
			if redraw:
				child.position.y = -y_extent
			else:
				child.queue_free()
				children.erase(child)

func create_new_cloud():
	var cloud_transparent_obj = cloud_transparent_scn.instance()
	cloud_transparent_obj.position = Vector2(0, -(randf() * 512))
	
	add_child(cloud_transparent_obj)
	children = get_children()

func enable_process(value):
	set_process(value)