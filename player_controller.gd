extends Node
@onready var player: Placeable = $".."
var tween_speed = 0.1
var currentPosition = Vector2(0,0)

var tween:Tween

func _ready() -> void:
	player.move_to_cell(Vector2i(0,2), on_move_finished)
	
func _process(delta: float) -> void:
	var input_dir = get_inputs_directions()
	if (TurnManager.is_player_turn() and input_dir != Vector2.ZERO):
		if(input_dir == player.facing):
			player.move_to_cell(GridManager.find_placeable_cell(player) + Vector2i(input_dir) , on_move_finished)
		else:
			player.rotate_toward(input_dir, on_move_finished)

func on_move_finished():
	SignalBus.emit_signal("player_moved")

func get_inputs_directions() -> Vector2:
	var horizontal = int(Input.is_action_just_pressed("game_right")) - int(Input.is_action_just_pressed("game_left"))
	var vertical = int(Input.is_action_just_pressed("game_down")) - int(Input.is_action_just_pressed("game_up"))
	return Vector2(horizontal, vertical)
