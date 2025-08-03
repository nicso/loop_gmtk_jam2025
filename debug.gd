extends Control
@onready var game_status: Label = %gameStatus

func _ready() -> void:
	SignalBus.connect("turn_changed", on_turn_finished)
	
func on_turn_finished(turn_type: int):
	game_status.text = TurnManager.get_current_turn_name()
	debug_grid()
	
func debug_grid():
	print("------------")
	for y in range(VarGlobals.grid_height):
		var row_str = ""
		for x in range(VarGlobals.grid_width):
			var placeable_name:String = GridManager.grid[y][x].name if GridManager.grid[y][x] else "."
			placeable_name = placeable_name.erase(1,placeable_name.length())
			row_str += str(placeable_name ) + " "
		print(row_str)
	print("------------")
