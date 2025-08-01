class_name EnnemyController
extends Node
@onready var ennemy: Node2D = $".."

var tween: Tween
func _ready() -> void:
	TurnManager.ennemies.push_back(ennemy)
	ennemy.move_to_cell(Vector2i(3,2), on_move_finished)
	
func on_move_finished():
	pass
