class_name BulletController
extends Node

var tween: Tween
@onready var bullet: Placeable = $".."
@export var starting_pos:Vector2i

func _ready() -> void:
	TurnManager.bullets.push_back(self)
	bullet.move_to_cell(starting_pos, on_move_finished)
	
func move(dir)->void:
	bullet.move_to_cell(dir, on_move_finished)
	

func on_move_finished():
	pass
