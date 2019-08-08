extends Node2D

var ANIMS = {
	"MENU_LOAD": "MenuLoad"
}
func _ready():
	$Anim.play(ANIMS.MENU_LOAD)
	pass # Replace with function body.

func _on_Start_pressed():
	var success = get_tree().change_scene("res://stages/apricot/StageApricot.tscn")
	print("change_scene: ", success)
	pass # Replace with function body.
