extends Path2D

onready var base_follow = $Follow
onready var base_sprite = $Base
onready var follow_container = $Follow_Container
export var max_count = 5
var current_count = 0
var killed = 0

var is_testing = true
var enemy_scene
var enemy_weapon_scene
var distance_to_each = 70
var speed = 2 # 2 pixel per process

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	create_follow_child(true)
	
	$Base.visible = is_testing
	$Button.visible = is_testing
	pass # Replace with function body.

func _process(delta):
#	$Follow.unit_offset += 0.001
	for i in get_children():
		if i.is_in_group("FOLLOWS") && i.is_in_group("LEADER"):
			if i.is_processing():
				i.offset += speed
	#			prints(i.offset, int(i.offset) % 50 == 0)
				if int(i.offset) % distance_to_each == 0:
					create_follow_child(false)
		elif i.is_in_group("FOLLOWS"):
			if i.is_processing():
				i.offset += speed
	if killed == max_count:
		queue_free()
	pass

func enable_process():
	set_process(!is_processing())
	pass

func _on_Button_pressed():
	set_process(!is_processing())
	pass # Replace with function body.

func create_follow_child(is_leader):
	if current_count < max_count:
		var enemy
		if is_testing:
			enemy = base_sprite.duplicate(8)
		else:
			enemy = enemy_scene.duplicate(15)
			enemy.current_atmosphere = enemy.atmosphere.LOWER
			enemy.connect("shoot", self, "_on_Shoot_Enemy")
			enemy.connect("died", self, "_on_Die_Enemy")
			enemy.is_to_animate_movement = false
			enemy.is_from_path = true
			enemy.enable_process(false)
			
		var follow = base_follow.duplicate(8)
		follow.add_child(enemy)
		follow.add_to_group("FOLLOWS")
		if is_leader:
			follow.add_to_group("LEADER")
		add_child(follow)
		follow.set_process(true)
		current_count += 1

func _on_Shoot_Enemy(position, damage):
	var weapon = enemy_weapon_scene.duplicate(15)
	weapon.position = position
	weapon.damage = damage
	weapon.current_atmosphere = weapon.atmosphere.LOWER
	weapon.add_to_group(weapon.GROUPS.LASER_ENEMY)
	get_node("../../Enemy-Projectiles-Lower").add_child(weapon)

func _on_Die_Enemy(value):
	killed += 1
	get_node("../../HUD").update_score(value)