extends Node2D
class_name Placeable

var tween
var facing := Vector2.RIGHT
var tweenSpeed := 0.1
@onready var sprite = get_node("Sprite2D")

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func move_to_cell(cell:Vector2i  , callback, teleport=false)->void:
	if GridManager.get_cell(GridManager.wrap_coordinates( cell) ) != null:
		return
	if sprite != null:
		sprite.visible = GridManager.is_cell_in_bounds(cell)
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	GridManager.set_cell(cell, self)
	if teleport:
		teleport(GridManager.get_cell_to_world_position(cell), callback)
	else:
		move(GridManager.get_cell_to_world_position(cell) , callback)
		
func teleport(position:Vector2i, callback):
	position = position
	
func move(position:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", position, tweenSpeed)
		tween.tween_callback(callback)
		if sprite != null:
			await tween.finished
			sprite.visible = true
	tween = null
	
func rotate_toward(dir:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		var newRotation = lerp_angle(self.rotation, dir.angle(), 1)
		facing = dir
		tween.tween_property(self, "rotation", newRotation, tweenSpeed)
		tween.tween_callback(callback)
	tween = null
