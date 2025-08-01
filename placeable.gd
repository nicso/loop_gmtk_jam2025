extends Node2D
class_name Placeable

var tween
var facing := Vector2.RIGHT
var tweenSpeed := 0.1
@onready var sprite = get_node("Sprite2D")

func _ready() -> void:
	for child in get_children():
		print("- ", child.name, " (", child.get_class(), ")")
	
func _process(delta: float) -> void:
	pass
	
func move_to_cell(cell:Vector2i, callback)->void:
	if GridManager.get_cell(wrap_coordinates( cell) ) != null:
		return
	if sprite != null:
		sprite.visible = is_cell_in_bounds(cell)
	GridManager.set_cell(GridManager.find_placeable_cell(self), null)
	GridManager.set_cell(cell, self)
	move(GridManager.get_cell_to_world_position(cell) , callback)
	print(GridManager.find_placeable_cell(self))


func is_cell_in_bounds(cell:Vector2i)->bool:
	if cell.x < 0 or cell.x  >= VarGlobals.grid_width:
		return false
	if cell.y < 0 or cell.y  >= VarGlobals.grid_height:
		return false
	return true

func wrap_coordinates(cell: Vector2i) -> Vector2i:
	var wrapped_x = cell.x % VarGlobals.grid_width
	var wrapped_y = cell.y % VarGlobals.grid_height
	
	if wrapped_x < 0:
		wrapped_x += VarGlobals.grid_width
	if wrapped_y < 0:
		wrapped_y += VarGlobals.grid_height
	
	return Vector2i(wrapped_x, wrapped_y)
	
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
