extends Node2D
class_name Placeable

var tween: Tween
var facing := Vector2.RIGHT
@onready var sprite: Sprite2D = get_node("Sprite2D")
const PLAYER = preload("res://assets/gfx/sprites/player.png")
const PLAYER_DOWN = preload("res://assets/gfx/sprites/player_down.png")
const PLAYER_UP = preload("res://assets/gfx/sprites/player_up.png")

@export var starting_cell : Vector2i

func _ready() -> void:
	SignalBus.connect("turn_finished", on_turn_finished)

func on_turn_finished()->void:
	#if not self.is_in_group("player"):
	sprite.flip_h = false if facing == Vector2.LEFT else true

func move_to_cell(cell:Vector2i  , callback, is_teleport=false)->void:
	var wrapped_cell = GridManager.wrap_coordinates(cell)
	if GridManager.get_cell(GridManager.wrap_coordinates( cell) ) != null:
		#if self.is_in_group("bullet"):
			#kill()
		callback.call()
		return
	if sprite != null:
		sprite.visible = GridManager.is_cell_in_bounds(cell)
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	GridManager.set_cell(wrapped_cell, self)
	if is_teleport:
		teleport(GridManager.get_cell_to_world_position(cell)+ Vector2.UP * VarGlobals.y_offset, callback)
	else:
		move(GridManager.get_cell_to_world_position(cell) + Vector2.UP * VarGlobals.y_offset , callback)
		#move(GridManager.get_cell_to_world_position(cell) , callback)

func kill()->void:
	print("paf")
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	TurnManager.bullets.erase(self)
	TurnManager.bullets = TurnManager.bullets.filter(func(bullet): return bullet != null)
	self.queue_free()
	
func teleport(to:Vector2i, callback):
	position = to
	callback.call()
	
func move(to:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		tween.set_trans(tween.TRANS_ELASTIC)
		tween.tween_property(self, "position", to, tween_speed())
		tween.tween_callback(callback)
		if sprite != null:
			await tween.finished
			sprite.visible = true
	tween = null
	
func rotate_toward(dir:Vector2, callback):
	#if not tween:
		#tween = get_tree().create_tween()
		#var newRotation = lerp_angle(self.rotation, dir.angle(), 1)
		#facing = dir
		#tween.tween_property(self, "rotation", newRotation, tween_speed())
		#tween.tween_callback(callback)
	#tween = null
	if self.is_in_group("player"):
		facing = dir
		match facing:
			Vector2(1,0):
				sprite.flip_h = true
				sprite.texture= PLAYER
			Vector2(-1,0):
				sprite.flip_h = false
				sprite.texture= PLAYER
			Vector2(0,1):
				sprite.flip_h = false
				sprite.texture= PLAYER_DOWN
			Vector2(0,-1):
				sprite.flip_h = false
				sprite.texture= PLAYER_UP
	callback.call()

func tween_speed()->float:
	return VarGlobals.player_tween if self.is_in_group("player") else VarGlobals.ennemy_tween
