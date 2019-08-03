extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Anim.play("MenuLoad")
	pass # Replace with function body.

func _on_Start_pressed():
	get_tree().change_scene("")
	pass # Replace with function body.
