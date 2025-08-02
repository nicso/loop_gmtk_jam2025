extends Node2D
class_name Placeable

var tween
var facing := Vector2.RIGHT
@onready var sprite: Sprite2D = get_node("Sprite2D")
const PLAYER = preload("res://assets/gfx/sprites/player.png")
const PLAYER_DOWN = preload("res://assets/gfx/sprites/player_down.png")
const PLAYER_UP = preload("res://assets/gfx/sprites/player_up.png")

func _ready() -> void:
	SignalBus.connect("turn_finished", on_turn_finished)

func on_turn_finished()->void:
	#if not self.is_in_group("player"):
	sprite.flip_h = false if facing == Vector2.LEFT else true

func _process(delta: float) -> void:
	pass
	
func move_to_cell(cell:Vector2i  , callback, teleport=false)->void:
	if GridManager.get_cell(GridManager.wrap_coordinates( cell) ) != null:
		if self.is_in_group("bullet"):
			print("paf")
		callback.call()
		return
	if sprite != null:
		sprite.visible = GridManager.is_cell_in_bounds(cell)
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	GridManager.set_cell(cell, self)
	if teleport:
		teleport(GridManager.get_cell_to_world_position(cell), callback)
	else:
		move(GridManager.get_cell_to_world_position(cell) + Vector2.UP * VarGlobals.y_offset , callback)
		
func teleport(position:Vector2i, callback):
	position = position
	
func move(position:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", position, tween_speed())
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
		print("facing ", facing)
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

func tween_speed()->float:
	return VarGlobals.player_tween if self.is_in_group("player") else VarGlobals.ennemy_tween
