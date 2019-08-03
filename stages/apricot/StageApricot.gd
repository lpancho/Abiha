extends Node2D

var number_of_waves = 5
var current_wave = 1
var laser_scn = load("res://player/weapon/laser/Laser.tscn")

onready var backgrounds = $Backgrounds
onready var clouds_transparent = $"Clouds-Transparent"
onready var clouds = $Clouds
onready var enemies_lower = $"Enemies-Lower"
onready var wave_anim = $"Wave-Details/Anim"
onready var ahiba = $Ahiba

func _ready():
	set_process(false)
	var connect_status = $Ahiba.connect("shoot_laser", self, "_on_Ahiba_shoot_laser")
	print("connect_status: ", connect_status)
	
	wave_anim.play("ShowCurrentWave")
	pass

func _process(delta):
	if enemies_lower.get_child_count() == 0:
		# proceed to next wave
		pass
	pass

# Signal methods
func _on_Ahiba_shoot_laser(player_position, damage):
	var laser = laser_scn.instance()
	laser.position = player_position
	laser.damage = damage
	$"Weapon-Lower".add_child(laser)

func _on_Anim_Wave_Details_animation_finished(anim_name):
	if anim_name == "ShowCurrentWave":
		$Anim.play("ShowAhiba")
	pass # Replace with function body.

func _on_Anim_Ahiba_animation_finished(anim_name):
	if anim_name == "ShowAhiba":
		
		enemies_lower.spawn()
		
		backgrounds.enable_process(true)
		clouds.enable_process(true)
		clouds_transparent.enable_process(true)
		ahiba.enable_process(true)
		set_process(true)
	pass # Replace with function body.
