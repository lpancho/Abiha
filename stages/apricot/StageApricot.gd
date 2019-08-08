extends Node2D

var number_of_waves = 5
var current_wave = 0
var laser_scn = load("res://shared_weapons/laser/Laser.tscn")

onready var backgrounds = $Backgrounds
onready var clouds_transparent = $"Clouds-Transparent"
onready var clouds = $Clouds
onready var enemies_lower = $"Enemies-Lower"
onready var wave_anim = $"Wave-Details/Anim"
onready var ahiba = $Ahiba

# stage design chance
var clouds_transparent_chance = 0.5
var clouds_chance = 0.2

func _ready():
	set_process(false)
	var connect_status = $Ahiba.connect("shoot_laser", self, "_on_Ahiba_shoot_laser")
	print("connect_status: ", connect_status)
	
	wave_anim.play("ShowCurrentWave")
	pass

func _process(delta):
	if current_wave != number_of_waves && enemies_lower.get_child_count() == 0:
		set_process(false)
		ahiba.can_shoot = false
		for projectile in $"Player-Projectiles-Lower".get_children():
			if "Laser" in projectile.name:
				projectile.remove_from_screen()
		for projectile in $"Enemy-Projectiles-Lower".get_children():
			if "Laser" in projectile.name:
				projectile.remove_from_screen()
				
		current_wave += 1
		$"Wave-Details/#".text = "#" + str(current_wave)
		$"Wave-Details/Subtitle".text = "Add another wave..."
		enable_background_process(false)
		wave_anim.play("ShowCurrentWave")
		pass
	
	# random cloud creation
	if clouds_transparent.get_child_count() == 0:
		randomize()
		var chance = randf() * 1
		if chance <= clouds_transparent_chance:
			clouds_transparent.create_new_cloud()
	if clouds.get_child_count() == 0:
		randomize()
		var chance = randf() * 1
		if chance <= clouds_chance:
			clouds.create_new_cloud()
	pass

# Signal methods
func _on_Ahiba_shoot_laser(player_position, damage, atmosphere):
	var laser = laser_scn.instance()
	laser.position = player_position
	laser.damage = damage
	laser.current_atmosphere = atmosphere
	if atmosphere == laser.atmosphere.UPPER:
		laser.scale = Vector2(1.5, 1.5)
	laser.add_to_group(laser.GROUPS.LASER_PLAYER)
	$"Player-Projectiles-Lower".add_child(laser)

func _on_Anim_Wave_Details_animation_finished(anim_name):
	if anim_name == "ShowCurrentWave":
		if current_wave == 0:
			$Anim.play("ShowAhiba")
		else:
			enemies_lower.position = Vector2(0, -512)
			enemies_lower.spawn()
			enable_background_process(true)
			$Anim.play("ShowEnemies")
	pass # Replace with function body.

func _on_Anim_Ahiba_animation_finished(anim_name):
	# This will be called for the first time the player gets into the stage
	if anim_name == "ShowAhiba":
		current_wave += 1
		enemies_lower.spawn()
		enable_background_process(true)
		ahiba.enable_process(true)
		$Anim.play("ShowEnemies")
	# This will be called for the first time the player gets into the stage
	# Also, for the succeeding waves
	elif anim_name == "ShowEnemies":
		get_tree().call_group("ENEMY", "enable_process", true)
		set_process(true)
		ahiba.can_shoot = true
	pass # Replace with function body.

func enable_background_process(value):
	backgrounds.enable_process(value)
	clouds.enable_process(value)
	clouds_transparent.enable_process(value)