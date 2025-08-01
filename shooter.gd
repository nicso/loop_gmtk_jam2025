extends Node
class_name Shooter
const BULLET = preload("res://bullet.tscn")
func shoot():
	var shooter_position = GridManager.find_placeable_cell(get_parent())
	var placeables_on_row = GridManager.get_placeables_on_rows(shooter_position)
	
	for placeable in placeables_on_row:
		if placeable.is_in_group("player") :
			var bullet = BULLET.instantiate() 
			var bulletController : BulletController = bullet.get_node("BulletController")
			bullet.position = GridManager.get_cell_to_world_position(Vector2i(shooter_position.x + player_direction(placeable).x , shooter_position.y))
			bulletController.starting_pos = Vector2i(shooter_position.x + player_direction(placeable).x , shooter_position.y)
			bullet.get_node("BulletController").direction = Vector2i(player_direction(placeable).x , 0)
			get_tree().root.add_child(bullet)
			break
			
func player_direction(player)->Vector2i:
	return GridManager.get_direction_to_target(
				GridManager.find_placeable_cell(get_parent()),
				GridManager.find_placeable_cell(player))
