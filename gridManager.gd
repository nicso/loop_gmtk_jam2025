extends Node

var grid_width := VarGlobals.grid_width
var grid_height := VarGlobals.grid_height
var grid: Array = []
const CELL = preload("res://cell.tscn")


func _ready() -> void:
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(null)
		grid.append(row)
	draw_grid()
	
func wrap_coordinates(cell: Vector2i) -> Vector2i:
	var wrapped_x = cell.x % grid_width
	var wrapped_y = cell.y % grid_height
	
	if wrapped_x < 0:
		wrapped_x += grid_width
	if wrapped_y < 0:
		wrapped_y += grid_height
	
	return Vector2i(wrapped_x, wrapped_y)
	
func set_cell(cell: Vector2i, placeable: Placeable):
	var wrapped_cell = wrap_coordinates(cell)
	grid[wrapped_cell.y][wrapped_cell.x] = placeable

func get_cell(cell: Vector2i) -> Placeable:
	if cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height:
		return grid[cell.y][cell.x]
	return null  

func get_cell_to_world_position(cell: Vector2i) -> Vector2:
	var wrapped_cell = wrap_coordinates(cell)
	var pos = Vector2(
		(wrapped_cell.x - grid_width/2.0) * VarGlobals.gridSize, 
		(wrapped_cell.y - grid_height/2.0) * VarGlobals.gridSize
	)
	return pos

func get_placeables_on_cols(cell:Vector2i) -> Array[Placeable]:
	var placeables:Array[Placeable]=[]
	for y in range(grid_height):
		if grid[y][cell.x] != null:
			placeables.append( grid[y][cell.x])
	return placeables

func get_placeables_on_rows(cell:Vector2i) -> Array[Placeable]:
	var placeables:Array[Placeable]=[]
	for x in range(grid_width):
		if grid[cell.y][x] != null:
			placeables.append( grid[cell.y][x])
	return placeables

func get_direction_to_target(cell:Vector2i, target:Vector2i)->Vector2i:
	var dir = Vector2i.ZERO
	dir.x = 1 if cell.x < target.x else -1
	dir.y = 1 if cell.y < target.y else -1
	return dir

func get_distance_between(cell:Vector2i, target:Vector2i)->int:
	var distance = abs(cell.x - target.x) + abs(cell.y - target.y)
	return distance

func is_cell_in_bounds(cell:Vector2i)->bool:
	if cell.x < 0 or cell.x  >= VarGlobals.grid_width:
		return false
	if cell.y < 0 or cell.y  >= VarGlobals.grid_height:
		return false
	return true
	
func draw_grid() -> void:
	for y in range(grid_height):
		for x in range(grid_width):
			var newCell = CELL.instantiate()
			newCell.position = get_cell_to_world_position(Vector2i(x, y))
			newCell.z_index = -500
			get_tree().root.add_child.call_deferred(newCell)

func find_placeable_cell(placeable: Placeable) -> Vector2i:
	for y in range(grid_height):
		for x in range(grid_width):
			if grid[y][x] == placeable:
				return Vector2i(x, y)
	return Vector2i(-1, -1)

func find_placeables_cell(placeable: Placeable) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(grid_height):
		for x in range(grid_width):
			if grid[y][x] == placeable:
				cells.append(Vector2i(x, y))
	return cells
