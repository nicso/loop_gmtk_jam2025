extends Control
@onready var game_status: Label = %gameStatus

func _ready() -> void:
	SignalBus.connect("turn_finished", on_turn_finished)
	
func on_turn_finished():
	print("pouet")
	game_status.text = TurnManager.state_to_string()
	
