extends Area2D

const MAX_SHOOT_TIMER = 10
var current_shoot_timer = MAX_SHOOT_TIMER
var can_shoot = true

var health = 3
var damage = 1
var can_take_damage = true

var prev_position
var ANIMS = { 
	"LEFT": "Left", 
	"TURN_LEFT": "Turn-Left", 
	"STEADY": "Steady", 
	"TURN_RIGHT": "Turn-Right", 
	"RIGHT": "Right"
}
var anim = ANIMS.STEADY

var move_modifier = 0.1

signal shoot_laser

func _ready():
	get_parent().get_node("HUD").update_life(health)
	enable_process(false)
	prev_position = position
	pass # Replace with function body.

func _process(delta):	
	# ship attack
	if can_shoot && Input.is_action_pressed("ui_left"):
		if current_shoot_timer == MAX_SHOOT_TIMER:
			emit_signal("shoot_laser", position, damage)
			current_shoot_timer = 0
		else:
			current_shoot_timer += 1
	
	# ship movement
	var new_position = (get_global_mouse_position() - position) * move_modifier
	translate(new_position)
	
#	new_position = (new_position - position) * 0.2
#	position.x = clamp(new_position.x, 10, 290)
#	position.y = clamp(new_position.y, 20, 512)
	
	var ship_pos = Vector2(int(position.x), int(position.y))
	if prev_position.x < ship_pos.x && anim != ANIMS.TURN_RIGHT && anim != ANIMS.RIGHT:
		anim = ANIMS.TURN_RIGHT
	elif prev_position.x < ship_pos.x && (anim == ANIMS.TURN_RIGHT || anim == ANIMS.RIGHT):
		anim = ANIMS.RIGHT
	elif prev_position.x > ship_pos.x && anim != ANIMS.TURN_LEFT && anim != ANIMS.LEFT:
		anim = ANIMS.TURN_LEFT
	elif prev_position.x > ship_pos.x && (anim == ANIMS.TURN_LEFT || anim == ANIMS.LEFT):
		anim = ANIMS.LEFT
	elif prev_position.x == ship_pos.x:
		anim = ANIMS.STEADY
	
#	prints(prev_position, position)
	$AnimMovement.play(anim)
	prev_position = ship_pos

func _on_Ahiba_area_entered(area):
	if area.is_in_group("ENEMY_LASER"):
		prints("can_take_damage: ", can_take_damage)
		if can_take_damage:
			health -= area.damage
			get_parent().get_node("HUD").update_life(health)
			if health == 0:
				can_shoot = false
				enable_process(false)
				$Sprite.visible = false
				$Explosion.visible = true
				$Explosion/Anim.play("Explode")
			else:
				can_take_damage = false
				$AnimAlpha.play("Invulnerable")
		else:
			pass
	pass # Replace with function body.

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()
	pass # Replace with function body.

func _on_AnimVulnerable_animation_finished(anim_name):
	if anim_name == "Invulnerable":
		can_take_damage = true
	pass # Replace with function body.

func enable_process(value):
	set_process(value)