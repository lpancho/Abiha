extends Area2D

var damage = 1
var speed = 150

var current_group
var GROUPS = {
	"PLAYER": "PLAYER",
	"ENEMY": "ENEMY",
	"LASER_ENEMY": "LASER_ENEMY",
	"LASER_PLAYER": "LASER_PLAYER"
}

var ANIMS = {
	"LEFT_HIT": "Left_Hit",
	"RIGHT_HIT": "Right_Hit"
}

# We use this anim pair because the sprite that we have contains
# left and right laser and its corresponding hit anim
enum SPRITE_PAIR {
	LEFT_LASER = 0,
	RIGHT_LASER = 1,
}
var sprite_pair

enum atmosphere {UPPER, LOWER}
var current_atmosphere

func _ready():
	randomize()
	sprite_pair = randi() % 2
	# +2 frames because the first two is for the hit anim
	$Sprite.frame = sprite_pair + 2 
	pass

func _process(delta):
	var new_position_y
	if is_in_group(GROUPS.LASER_ENEMY):
		new_position_y = position.y + speed * delta
	elif is_in_group(GROUPS.LASER_PLAYER):
		new_position_y = position.y - speed * delta
	position.y = new_position_y
	pass

func _on_Laser_area_entered(area):
	# check if the laser comes from enemy or player
	var to_enemy = false
	var to_player = false
	var is_same_atmosphere = area.current_atmosphere == current_atmosphere
	if is_in_group(GROUPS.LASER_ENEMY):
		to_player = area.is_in_group(GROUPS.PLAYER)
	elif is_in_group(GROUPS.LASER_PLAYER):
		to_enemy = area.is_in_group(GROUPS.ENEMY)
	
	# currently they have the same contents
	if to_enemy && is_same_atmosphere:
		if !area.get_node("Collision").disabled:
			if area.health == 0:
				area.get_node("Collision").set_deferred("disabled", true)
			remove_from_screen()
	elif to_player && is_same_atmosphere:
		if !area.get_node("Collision").disabled:
			if area.health == 0:
				area.get_node("Collision").set_deferred("disabled", true)
			remove_from_screen()
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == ANIMS.LEFT_HIT || anim_name == ANIMS.RIGHT_HIT:
		queue_free()

func _on_Visibility_screen_exited():
	queue_free()
	pass # Replace with function body

func remove_from_screen():
	set_process(false)
	if sprite_pair == SPRITE_PAIR.LEFT_LASER:
		$Anim.play(ANIMS.LEFT_HIT)
	elif sprite_pair == SPRITE_PAIR.RIGHT_LASER:
		$Anim.play(ANIMS.RIGHT_HIT)
