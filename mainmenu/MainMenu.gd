extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Anim.play("MenuLoad")
	pass # Replace with function body.

func _on_Start_pressed():
	var success = get_tree().change_scene("res://stages/apricot/StageApricot.tscn")
	print("change_scene: ", success)
	pass # Replace with function body.
