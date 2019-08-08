extends Area2D

const MAX_SHOOT_TIMER = 50
var current_shoot_timer = MAX_SHOOT_TIMER

var health = 1
var damage = 1
var score = 1

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
		emit_signal("shoot", position, damage)
		current_shoot_timer = 0
	else:
		current_shoot_timer += 1

func _on_Anzimusbig_area_entered(area):
	var is_same_atmosphere = area.current_atmosphere == current_atmosphere
	if area.is_in_group(GROUPS.PLAYER) && is_same_atmosphere:
		area.health -= damage
		$Sprite.visible = false
		$Explosion.visible = true
		$Explosion/Anim.play(ANIMS.EXPLODE)
	elif area.is_in_group(GROUPS.LASER_PLAYER) && is_same_atmosphere:
		health -= area.damage
		
		if health == 0:
			emit_signal("died", score)
			$Sprite.visible = false
			$Explosion.visible = true
			$Explosion/Anim.play(ANIMS.EXPLODE)

func _on_Anim_animation_finished(anim_name):
	if anim_name == ANIMS.EXPLODE:
		queue_free()

func enable_process(value) -> void:
	set_process(value)
	if value:
		$AnimMovement.play(ANIMS.MOVE)
		$AnimFrame.play(ANIMS.MOVE)
