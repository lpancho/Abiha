extends CanvasLayer

var score = 0
var life = 0
onready var score_node = $VBoxContainer/Score
onready var life_node = $VBoxContainer/Life

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(score)
	update_life(life)
	pass # Replace with function body.

func update_score(value) -> void:
	score += value
	score_node.text = "Score: " + str(score)

func update_life(value) -> void:
	life_node.text = "Life: " + str(value)
