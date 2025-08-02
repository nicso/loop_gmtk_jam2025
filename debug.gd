extends Control
@onready var game_status: Label = %gameStatus


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	game_status.text = TurnManager.state_to_string()
