extends Node2D

var laser_scn = load("res://player/weapon/laser/Laser.tscn")

func _ready():
	var connect_status = $Ahiba.connect("shoot_laser", self, "_on_Ahiba_shoot_laser")
	print("connect_status: ", connect_status) 
	pass

# Signal methods
func _on_Ahiba_shoot_laser(player_position, damage):
	var laser = laser_scn.instance()
	laser.position = player_position
	laser.damage = damage
	$"Weapon-Lower".add_child(laser)