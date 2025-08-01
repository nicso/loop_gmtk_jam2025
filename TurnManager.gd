extends Node
enum STATES {PLAYER_TURN, ENNEMI_TURN}
var game_state : STATES = STATES.PLAYER_TURN
var ennemies = []

func _ready() -> void:
	SignalBus.connect("player_moved", on_player_moved)
	

	
func _process(delta: float) -> void:
	match game_state:
		STATES.PLAYER_TURN:
			pass
		STATES.ENNEMI_TURN:
			for ennemy in ennemies:
				await ennemy.move_to_cell(GridManager.find_placeable_cell(ennemy)+Vector2i.DOWN, on_ennemy_moved)
			game_state = STATES.PLAYER_TURN
			pass

func on_ennemy_moved():
	pass

func on_player_moved():
	game_state= STATES.ENNEMI_TURN

func is_player_turn()->bool:
	return game_state == STATES.PLAYER_TURN

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
