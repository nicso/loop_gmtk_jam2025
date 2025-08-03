class_name BulletController
extends Node

var tween: Tween
@onready var bullet: Placeable = $".."
@export var starting_pos:Vector2i
var direction := Vector2i.RIGHT
var is_moving: bool = false
var has_moved_from_spawn: bool = true

func _ready() -> void:
	TurnManager.add_bullet(self)
	bullet.move_to_cell(bullet.starting_cell, on_move_finished, true)
	bullet.facing = Vector2(direction)
	#bullet.position = GridManager.get_cell_to_world_position(bullet.starting_cell )+ Vector2.UP * VarGlobals.y_offset
	
func move(pos)->void:
	if is_moving:
		return
	is_moving = true
	
	if has_moved_from_spawn:
		bullet.move_to_cell(pos + direction, on_move_finished)
	else:
		has_moved_from_spawn = true
		on_move_finished()
	
func on_move_finished():
	is_moving = false
