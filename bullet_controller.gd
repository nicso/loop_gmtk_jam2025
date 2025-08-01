class_name BulletController
extends Node

var tween: Tween
@onready var bullet: Placeable = $".."
@export var starting_pos:Vector2i
var direction := Vector2i.RIGHT

func _ready() -> void:
	TurnManager.bullets.push_back(self)
	bullet.move_to_cell(starting_pos, on_move_finished, true)
	bullet.rotation = Vector2(direction).angle()
	
func move(pos)->void:
	bullet.move_to_cell(pos+direction, on_move_finished)
	
func on_move_finished():
	pass
