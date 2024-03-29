extends Node2D

var laser_scn = load("res://shared_weapons/laser/Laser.tscn")
var enemies = [
	load("res://enemies/anzimus-big/Anzimus-big.tscn")
]

# Default positions
var positions = [
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40)]),
	PoolVector2Array([Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)]),
	PoolVector2Array([Vector2(40, 40),Vector2(110, 40),Vector2(180, 40),Vector2(250, 40),Vector2(75, 80),Vector2(145, 80),Vector2(215, 80),Vector2(110, 120),Vector2(185, 120),Vector2(145, 160)])
]

# Paths
var paths = [
	load("res://paths/LeftDown_2Zigzag_UpRight.tscn")
]

func _ready():
	print(position)

func spawn():
	var enemy_position = positions[randi() % positions.size()]
	var enemies_to_spawn = enemy_position.size()
	var index = 0
	for i in enemies_to_spawn:
		var enemy = enemies[randi() % enemies.size()].instance()
		enemy.position = enemy_position[index]
		enemy.current_atmosphere = enemy.atmosphere.LOWER
		enemy.connect("shoot", self, "_on_Shoot_Enemy")
		enemy.connect("died", self, "_on_Die_Enemy")
		add_child(enemy)
		index += 1

func spawn_with_path():
	var path = paths[randi() % paths.size()].instance()
	path.is_testing = false
	path.distance_to_each = 50
	path.enemy_scene = enemies[randi() % enemies.size()].instance()
	path.enemy_weapon_scene = laser_scn.instance()
	add_child(path)
	path.enable_process()

func _on_Shoot_Enemy(position, damage):
	var laser = laser_scn.instance()
	laser.position = position
	laser.damage = damage
	laser.current_atmosphere = laser.atmosphere.LOWER
	laser.add_to_group(laser.GROUPS.LASER_ENEMY)
	get_parent().get_node("Enemy-Projectiles-Lower").add_child(laser)

func _on_Die_Enemy(value):
	get_parent().get_node("HUD").update_score(value)