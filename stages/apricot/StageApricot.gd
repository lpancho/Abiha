extends Node2D

var number_of_waves = 5
var current_wave = 1
var laser_scn = load("res://player/weapon/laser/Laser.tscn")

onready var enemies_lower_count = $"Enemies-Lower".get_child_count()

func _ready():
	var connect_status = $Ahiba.connect("shoot_laser", self, "_on_Ahiba_shoot_laser")
	print("connect_status: ", connect_status)
	pass

func _process(delta):
	if enemies_lower_count == 0:
		# proceed to next wave
		pass
	pass

# Signal methods
func _on_Ahiba_shoot_laser(player_position, damage):
	var laser = laser_scn.instance()
	laser.position = player_position
	laser.damage = damage
	$"Weapon-Lower".add_child(laser)