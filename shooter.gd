extends Node
class_name Shooter

func shoot():
	var shooter_position = GridManager.find_placeable_cell(get_parent())
	var placeables_on_row = GridManager.get_placeables_on_rows(shooter_position)
	
	for placeable in placeables_on_row:
		if placeable.is_in_group("player") :
			print("pew - joueur détecté -> ", GridManager.get_direction_to_target(
				GridManager.find_placeable_cell(get_parent()),
				GridManager.find_placeable_cell(placeable)
			))
			break
