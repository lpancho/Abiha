extends Area2D

const MAX_SHOOT_TIMER = 50
var current_shoot_timer = MAX_SHOOT_TIMER

var health = 1
var damage = 1

signal shoot

func _ready():
	$Explosion.visible = false
	$AnimMovement.play("Move")
	$AnimFrame.play("Move")

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
			$Sprite.visible = false
			$Explosion.visible = true
			$Explosion/Anim.play("Explode")

func _on_Anim_animation_finished(anim_name):
	queue_free()
	pass # Replace with function body.
