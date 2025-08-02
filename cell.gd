extends Sprite2D
class_name Cell

@export var colors: Array[Color]

func random_color():
	modulate = colors.pick_random()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
