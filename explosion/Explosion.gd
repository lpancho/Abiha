extends Sprite

func explode():
	$Anim.play("Explode")

func _on_Anim_animation_finished(anim_name):
	queue_free()
	pass # Replace with function body.
