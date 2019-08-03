extends Area2D

var damage = 1
var speed = 150

enum ANIMS {
	LEFT_HIT = 0,
	RIGHT_HIT = 1,
	LEFT_LASER = 2,
	RIGHT_LASER = 3,
}
var anim

func _ready():
	randomize()
	anim = randi() % 2 + 2
	$Sprite.frame = anim

func _process(delta):
	var new_position_y = position.y + speed * delta
	position.y = new_position_y

func _on_Laser_area_entered(area):
	if area.is_in_group("PLAYER"):
		set_process(false)
		if anim == ANIMS.LEFT_LASER:
			$Anim.play("Left_Hit")
		elif anim == ANIMS.RIGHT_LASER:
			$Anim.play("Right_Hit")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Left_Hit" || anim_name == "Right_Hit":
		queue_free()

func _on_Visibility_screen_exited():
	queue_free()
	pass # Replace with function body.
