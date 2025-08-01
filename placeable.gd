extends Node2D
class_name Placeable

var tween
var facing := Vector2.RIGHT
var tweenSpeed := 0.1

func _ready() -> void:
	pass # Replace with function body.

	
func _process(delta: float) -> void:
	pass
	
func move_to_cell(cell:Vector2i, callback)->void:
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	GridManager.set_cell(cell, self)
	move(GridManager.get_cell_to_world_position(cell) , callback)
	print(GridManager.find_placeable_cell(self))

func move(position:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", position, tweenSpeed)
		tween.tween_callback(callback)
	tween = null
	
	
func rotate_toward(dir:Vector2, callback):
	if not tween:
		tween = get_tree().create_tween()
		var newRotation = lerp_angle(self.rotation, dir.angle(), 1)
		facing = dir
		tween.tween_property(self, "rotation", newRotation, tweenSpeed)
		tween.tween_callback(callback)
	tween = null
