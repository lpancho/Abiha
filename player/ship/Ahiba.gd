extends Area2D

const MAX_SHOOT_TIMER = 10
var current_shoot_timer = MAX_SHOOT_TIMER

var can_take_damage = true

var health = 3
var damage = 1

var prev_position
var ANIMS = { 
	"LEFT": "Left", 
	"TURN_LEFT": "Turn-Left", 
	"STEADY": "Steady", 
	"TURN_RIGHT": "Turn-Right", 
	"RIGHT": "Right"
}
var anim = ANIMS.STEADY

var move_modifier = 0.2

signal shoot_laser

func _ready():
	prev_position = position
	pass # Replace with function body.

func _process(delta):	
	# ship attack
	if Input.is_action_pressed("ui_left"):
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
	$Anim.play(anim)
	prev_position = ship_pos

func _on_Ahiba_area_entered(area):
	if area.is_in_group("ENEMY_LASER"):
		print(can_take_damage)
		print("hi")
		if can_take_damage:
			print("here")
			health -= area.damage
			if health == 0:
				$Sprite.visible = false
				$Explosion.visible = true
				$Explosion/Anim.play("Explode")
			else:
				can_take_damage = false
				$Anim.play("Invulnerable")
		else:
			pass
	pass # Replace with function body.

func _on_Anim_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "Invulnerable":
		can_take_damage = true
	if anim_name == "Explode":
		queue_free()
	pass # Replace with function body.
