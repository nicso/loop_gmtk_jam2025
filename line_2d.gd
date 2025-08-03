extends Line2D
@onready var bullet: Placeable = $".."


var offset = -256.0

func _ready() -> void:
	#SignalBus.connect("ennemies_turn_finished", on_turn_finished)
	#on_turn_finished()
	pass

#func on_turn_finished():
	#offset = 512


func _process(delta: float) -> void:
	#offset -= delta * 1000.0
	#offset = max(0,offset)
	offset = lerp(offset, 0.0, delta * 5.0)
	for i in range(points.size()):
		if i == 0:
			set_point_position(i, bullet.global_position - bullet.facing * (i * 128 ))
		else:
			set_point_position(i, bullet.global_position - bullet.facing * (i * 128 + offset))


func reset():
	await wait(0.3)
	offset = 314.0
	print("line reset")

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
