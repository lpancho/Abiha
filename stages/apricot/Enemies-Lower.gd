extends Node2D

var laser_scn = load("res://enemies/weapon/laser/Laser.tscn")
var enemies = [
	load("res://enemies/anzimus-big/Anzimus-big.tscn")
]

var positions = [
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40)]),
	PoolVector2Array([Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)]),
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40),Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)])
]

func spawn():
	var position = positions[0]
	var enemies_to_spawn = position.size()
	var index = 0
	for i in enemies_to_spawn:
		var enemy = enemies[0].instance()
		enemy.position = position[index]
		enemy.connect("shoot", self, "_on_Shoot_Enemy")
		add_child(enemy)
		index += 1

func _on_Shoot_Enemy(position, damage):
	var laser = laser_scn.instance()
	laser.position = position
	laser.damage = damage
	get_parent().add_child(laser)