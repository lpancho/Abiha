extends Node2D

var enemies = [
	load("res://enemies/anzimus-big/Anzimus-big.tscn")
]

var positions = [
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40)]),
	PoolVector2Array([Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)]),
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40),Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)])
]

#var children

func _ready():
	enable_process(false)
#	children = get_children()
#	for child in children:
#		print("Vector2" + str(child.position) + ",")
	spawn()
	
	pass # Replace with function body.

func spawn():
	var position = positions[0]
	var enemies_to_spawn = position.size()
	var index = 0
	for i in enemies_to_spawn:
		var enemy = enemies[0].instance()
		enemy.position = position[index]
		add_child(enemy)
		index += 1

func enable_process(value):
	set_process(value)