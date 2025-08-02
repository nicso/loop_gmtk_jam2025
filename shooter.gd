extends Node
class_name Shooter
const BULLET = preload("res://bullet.tscn")
@onready var player: Placeable = %Player

func shoot():
	var shooter_position = GridManager.find_placeable_cell(get_parent())
	var placeables_on_row = GridManager.get_placeables_on_rows(shooter_position)
	if distance_to_player() <= 2:
		return
	for placeable in placeables_on_row:
		if placeable.is_in_group("player") :
			var bullet = BULLET.instantiate() 
			var bulletController : BulletController = bullet.get_node("BulletController")
			var player_direction = GridManager.placeable_direction(placeable, get_parent())
			
			bullet.position = GridManager.get_cell_to_world_position(Vector2i(shooter_position.x + player_direction.x , shooter_position.y))
			bulletController.starting_pos = Vector2i(shooter_position.x + player_direction.x , shooter_position.y)
			bullet.get_node("BulletController").direction = Vector2i(player_direction.x , 0)
			get_tree().root.add_child(bullet)
			break


func distance_to_player()->int:
	var from = GridManager.find_placeable_cell(get_parent())
	var to = GridManager.find_placeable_cell(player)
	return GridManager.distance_between(from, to)
	
