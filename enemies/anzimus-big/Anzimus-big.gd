extends Area2D

const MAX_SHOOT_TIMER = 50
var current_shoot_timer = MAX_SHOOT_TIMER

var health = 1
var damage = 1
var score = 1

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
	if area.is_in_group("PLAYER"):
		area.health -= damage
		$Sprite.visible = false
		$Explosion.visible = true
		$Explosion/Anim.play("Explode")
	elif area.is_in_group("LASER"):
		health -= area.damage
		
		if health == 0:
			emit_signal("died", score)
			$Sprite.visible = false
			$Explosion.visible = true
			$Explosion/Anim.play("Explode")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()

func enable_process(value) -> void:
	set_process(value)
	if value:
		$AnimMovement.play("Move")
		$AnimFrame.play("Move")
