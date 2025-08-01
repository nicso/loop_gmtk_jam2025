class_name EnnemyController
extends Node
@onready var ennemy: Placeable = $".."
@export var starting_pos:Vector2i
var tween: Tween

func _ready() -> void:
	TurnManager.ennemies.push_back(self)
	ennemy.move_to_cell(starting_pos, on_move_finished)

func move(dir)->void:
	ennemy.move_to_cell(dir, on_move_finished)
	
func on_move_finished():
	pass
