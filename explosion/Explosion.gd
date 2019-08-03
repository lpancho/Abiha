extends Sprite

func _ready():
	visible = false

func explode():
	$Anim.play("Explode")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()
	pass # Replace with function body.
