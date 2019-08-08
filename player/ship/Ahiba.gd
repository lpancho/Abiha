extends Area2D

const MAX_SHOOT_TIMER = 10
var current_shoot_timer = MAX_SHOOT_TIMER
var can_shoot = true

var health = 3
var damage = 1
var can_take_damage = true

var GROUPS = {
	"LOWER": "LOWER",
	"UPPER": "UPPER",
	"LASER_ENEMY": "LASER_ENEMY"
}
var ANIMS_OTHER = {
	"EXPLODE": "Explode"
}
var ANIMS_PLAYER = { 
	"LEFT": "Left", 
	"TURN_LEFT": "Turn-Left", 
	"STEADY": "Steady", 
	"TURN_RIGHT": "Turn-Right", 
	"RIGHT": "Right",
	"INVULNERABLE": "Invulnerable",
	"ZOOM_IN": "Zoom-In"
}
var anim = ANIMS_PLAYER.STEADY

enum atmosphere {UPPER, LOWER}
var current_atmosphere
var prev_position
var move_modifier = 0.1

signal shoot_laser

func _ready():
	get_parent().get_node("HUD").update_life(health)
	enable_process(false)
	prev_position = position
	current_atmosphere = atmosphere.LOWER
	add_to_group(GROUPS.LOWER)
	pass # Replace with function body.

func _process(delta):	
	# ship attack
	if can_shoot && Input.is_action_pressed("ui_left"):
		if current_shoot_timer == MAX_SHOOT_TIMER:
			emit_signal("shoot_laser", position, damage, current_atmosphere)
			current_shoot_timer = 0
		else:
			current_shoot_timer += 1
	if Input.is_action_just_pressed("ui_accept"):
		if current_atmosphere == atmosphere.LOWER:
			$AnimZoom.play(ANIMS_PLAYER.ZOOM_IN)
		else:
			$AnimZoom.play_backwards(ANIMS_PLAYER.ZOOM_IN)
			
	# ship movement
	var new_position = (get_global_mouse_position() - position) * move_modifier
	translate(new_position)
	
#	new_position = (new_position - position) * 0.2
#	position.x = clamp(new_position.x, 10, 290)
#	position.y = clamp(new_position.y, 20, 512)
	
	var ship_pos = Vector2(int(position.x), int(position.y))
	if prev_position.x < ship_pos.x && anim != ANIMS_PLAYER.TURN_RIGHT && anim != ANIMS_PLAYER.RIGHT:
		anim = ANIMS_PLAYER.TURN_RIGHT
	elif prev_position.x < ship_pos.x && (anim == ANIMS_PLAYER.TURN_RIGHT || anim == ANIMS_PLAYER.RIGHT):
		anim = ANIMS_PLAYER.RIGHT
	elif prev_position.x > ship_pos.x && anim != ANIMS_PLAYER.TURN_LEFT && anim != ANIMS_PLAYER.LEFT:
		anim = ANIMS_PLAYER.TURN_LEFT
	elif prev_position.x > ship_pos.x && (anim == ANIMS_PLAYER.TURN_LEFT || anim == ANIMS_PLAYER.LEFT):
		anim = ANIMS_PLAYER.LEFT
	elif prev_position.x == ship_pos.x:
		anim = ANIMS_PLAYER.STEADY
	
#	prints(prev_position, position)
	$AnimMovement.play(anim)
	prev_position = ship_pos

func _on_Ahiba_area_entered(area):
	if area.is_in_group(GROUPS.LASER_ENEMY):
		
		var is_in_same_atmosphere = area.current_atmosphere == self.current_atmosphere		
		if can_take_damage && is_in_same_atmosphere:
			health -= area.damage
			get_parent().get_node("HUD").update_life(health)
			if health == 0:
				can_shoot = false
				enable_process(false)
				$Sprite.visible = false
				$Explosion.visible = true
				$Explosion/Anim.play(ANIMS_OTHER.EXPLODE)
			else:
				can_take_damage = false
				$AnimAlpha.play(ANIMS_PLAYER.INVULNERABLE)
		else:
			pass
	pass # Replace with function body.

func _on_Anim_animation_finished(anim_name):
	if anim_name == ANIMS_OTHER.EXPLODE:
		queue_free()
	pass # Replace with function body.

func _on_AnimVulnerable_animation_finished(anim_name):
	if anim_name == ANIMS_PLAYER.INVULNERABLE:
		can_take_damage = true
	pass # Replace with function body.

func _on_AnimZoom_animation_finished(anim_name):
	if anim_name == ANIMS_PLAYER.ZOOM_IN:
		if current_atmosphere == atmosphere.LOWER:
			current_atmosphere = atmosphere.UPPER
			remove_from_group(GROUPS.LOWER)
			add_to_group(GROUPS.UPPER)
			z_index += 2
		else:
			current_atmosphere = atmosphere.LOWER
			remove_from_group(GROUPS.UPPER)
			add_to_group(GROUPS.LOWER)
			z_index -= 2
	pass # Replace with function body.

func enable_process(value):
	set_process(value)


