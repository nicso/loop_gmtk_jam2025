class_name EnnemyController
extends Node
@onready var ennemy: Placeable = $".."
@onready var shooter = get_parent().get_node("Shooter")
@export var starting_pos:Vector2i
@onready var player: Placeable = %Player


var tween: Tween
var is_moving: bool = false

func _ready() -> void:
	TurnManager.ennemies.push_back(self)
	ennemy.move_to_cell(starting_pos, on_move_finished)

func move(dir)->void:
	if is_moving:
		return 
	is_moving = true
	ennemy.move_to_cell(dir, on_move_finished)
	
func on_move_finished():
	is_moving = false
	if shooter != null:
		shooter.shoot()
	
