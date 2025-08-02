class_name EnnemyController
extends Node
@onready var ennemy: Placeable = $".."
@onready var shooter = get_parent().get_node("Shooter")
@onready var player: Placeable = TurnManager.player

var tween: Tween
var is_moving: bool = false

func _ready() -> void:
	TurnManager.ennemies.append(self)
	ennemy.move_to_cell(ennemy.starting_cell, on_move_finished, true)
	SignalBus.connect("turn_finished", on_end_of_turn)

func move(dir)->void:
	if is_moving:
		return 
	is_moving = true
	ennemy.move_to_cell(dir, on_move_finished)
	
func on_move_finished()->void:
	is_moving = false
	if shooter != null:
		shooter.shoot()

func on_end_of_turn()->void:
	if GridManager.find_placeable_cell(player).x > GridManager.find_placeable_cell(ennemy).x:
		ennemy.facing = Vector2i.LEFT
	else:
		ennemy.facing = Vector2i.RIGHT
