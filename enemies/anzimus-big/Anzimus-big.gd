extends Area2D

const MAX_SHOOT_TIMER = 50
var current_shoot_timer = MAX_SHOOT_TIMER

var health = 1
var damage = 1
var score = 1
var is_to_animate_movement = true
var is_to_animate_frame = true
var is_from_path = false

var GROUPS = {
	"PLAYER": "PLAYER",
	"LASER_PLAYER": "LASER_PLAYER"
}

var ANIMS = {
	"EXPLODE": "Explode",
	"MOVE": "Move"
}

enum atmosphere {UPPER, LOWER}
var current_atmosphere

signal shoot
signal died

func _ready():
	enable_process(false)
	$Explosion.visible = false

func _process(delta):
	if current_shoot_timer == MAX_SHOOT_TIMER:
		var current_position = position
		if is_from_path:
			current_position = self.get_parent().position
		emit_signal("shoot", current_position, damage)
		current_shoot_timer = 0
	else:
		current_shoot_timer += 1

func _on_Anzimusbig_area_entered(area):
	var is_same_atmosphere = area.current_atmosphere == current_atmosphere
	if area.is_in_group(GROUPS.PLAYER) && is_same_atmosphere:		
		if is_from_path:
			get_parent().set_process(false)
		else:
			set_process(false)
				
		$Sprite.visible = false
		$Explosion.visible = true
		$Explosion/Anim.play(ANIMS.EXPLODE)
	elif area.is_in_group(GROUPS.LASER_PLAYER) && is_same_atmosphere:
		health -= area.damage
		
		if health == 0:
			
			if is_from_path:
				get_parent().set_process(false)
			else:
				set_process(false)
			
			emit_signal("died", score)
			$Sprite.visible = false
			$Explosion.visible = true
			$Explosion/Anim.play(ANIMS.EXPLODE)

func _on_Anim_animation_finished(anim_name):
	if anim_name == ANIMS.EXPLODE:
		if is_from_path:
			get_parent().queue_free()
		else:
			queue_free()

func enable_process(value) -> void:
	set_process(value)
	if value:
		if is_to_animate_movement:
			$AnimMovement.play(ANIMS.MOVE)
		if is_to_animate_frame:
			$AnimFrame.play(ANIMS.MOVE)
