extends Node2D

export var speed = 20
var y_extent = 510
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

func enable_process(value):
	set_process(value)