extends Node
class_name Shooter
const BULLET = preload("res://bullet.tscn") 
@onready var player: Placeable = TurnManager.player

func shoot():
	var shooter_position :Vector2i = GridManager.find_placeable_cell(get_parent())
	var placeables_on_row = GridManager.get_placeables_on_rows(shooter_position)
	if distance_to_player() <= 2:
		return
	for placeable in placeables_on_row:
		if placeable.is_in_group("player") :
			var bullet_spawn_cell = shooter_position + GridManager.placeable_direction(placeable, get_parent()) 
			if GridManager.get_cell(bullet_spawn_cell) == null:
				var bullet:Placeable = BULLET.instantiate() 
				var player_direction = GridManager.placeable_direction(placeable, get_parent())
				
				bullet.starting_cell = bullet_spawn_cell
				bullet.get_node("BulletController").direction = Vector2i(player_direction.x , 0)
				get_tree().root.add_child(bullet)
				break
			else :
				print("could’nt shoot", GridManager.get_cell(bullet_spawn_cell).name)


func distance_to_player()->int:
	var from = GridManager.find_placeable_cell(get_parent())
	var to = GridManager.find_placeable_cell(player)
	return GridManager.distance_between(from, to)
	
