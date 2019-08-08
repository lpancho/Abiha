extends Sprite

var ANIMS = {
	"EXPLODE": "Explode"
}

func _ready():
	visible = false

func explode():
	$Anim.play(ANIMS.EXPLODE)

func _on_Anim_animation_finished(anim_name):
	if anim_name == ANIMS.EXPLODE:
		queue_free()
	pass # Replace with function body.
