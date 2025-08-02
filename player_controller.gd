extends Node
@onready var player: Placeable = $".."
var tween_speed = 0.1
var currentPosition = Vector2(0,0)

var tween:Tween
var input_map = {
	"game_right": Vector2.RIGHT,
	"game_left": Vector2.LEFT,
	"game_down": Vector2.DOWN,
	"game_up": Vector2.UP
}
func _ready() -> void:
	TurnManager.player = get_parent()
	player.move_to_cell(Vector2i(0,2), on_move_finished, true)
	
func _process(_delta: float) -> void:
	var input_dir = get_inputs_directions()
	if (TurnManager.is_player_turn() and input_dir != Vector2.ZERO):
		if(input_dir == player.facing):
			player.move_to_cell(GridManager.find_placeable_cell(player) + Vector2i(input_dir) , on_move_finished)
		else:
			player.rotate_toward(input_dir, on_move_finished)

func on_move_finished():
	SignalBus.emit_signal("player_turn_finished")

func get_inputs_directions() -> Vector2:
	for action in input_map:
		if Input.is_action_just_pressed(action):
			return input_map[action]
	return Vector2.ZERO
