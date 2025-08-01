class_name EnnemyController
extends Node
@onready var ennemi: Node2D = $".."

var tween: Tween
func _ready() -> void:
	TurnManager.ennemies.push_back(ennemi)

func move(dir):
	if not tween :
		tween = get_tree().create_tween()
		var newPos = ennemi.position + dir * VarGlobals.gridSize
		tween.tween_property(ennemi, "position", newPos, 0.1)
	await tween.finished
	tween = null
