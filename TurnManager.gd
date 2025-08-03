extends Node
enum STATES {PLAYER_TURN, ENNEMI_TURN, BULLET_TURN}
var game_state : STATES = STATES.PLAYER_TURN
var ennemies = []
var bullets = []
var player : Placeable

func _ready() -> void:
	SignalBus.connect("player_turn_finished", on_player_moved)
	#SignalBus.connect("ennemies_turn_finished", on_ennemies_moved)
	#SignalBus.connect("bullets_turn_finished", on_bullets_moved)

func state_to_string()->String:
	match game_state:
		STATES.PLAYER_TURN:
			return "player turn"
		STATES.ENNEMI_TURN:
			return "ennemi turn"
		STATES.BULLET_TURN:
			return "bullet turn"
	return "no turn"
	
func on_player_moved()->void:
	print("pouet", game_state)
	if game_state == STATES.PLAYER_TURN:
		game_state = STATES.BULLET_TURN
		#SignalBus.emit_signal("player_turn_finished")
		SignalBus.emit_signal("turn_finished")
		await process_bullets_turn()
		
func process_ennemy_turn()->void:
	print("--- ennemy turn ---")
	ennemies = ennemies.filter(func(ennemy): return ennemy != null and is_instance_valid(ennemy) and is_instance_valid(ennemy.ennemy))
	for n in range(ennemies.size()):
		var ennemy:EnnemyController = ennemies[n]
		var current_pos = GridManager.find_placeable_cell(ennemy.ennemy)
		ennemy.move(current_pos + Vector2i.DOWN)
		await ennemy.ennemy.tween.finished if ennemy.ennemy.tween else get_tree().process_frame
	game_state = STATES.PLAYER_TURN
	SignalBus.emit_signal("ennemies_turn_finished")
	SignalBus.emit_signal("turn_finished")
	#await process_player_turn()

func process_bullets_turn()->void:
	print("--- bullet turn ---")
	bullets = bullets.filter(func(bullet): return bullet != null and is_instance_valid(bullet) and is_instance_valid(bullet.bullet))
	for n in range(bullets.size()):
		print("avant ",bullets[n].get_parent().position.y)
	bullets.sort_custom(func(a: BulletController, b: BulletController):
		var pos_a = GridManager.find_placeable_cell(a.bullet)
		var pos_b = GridManager.find_placeable_cell(b.bullet)
		
		if pos_a.y != pos_b.y:
			return pos_a.y < pos_b.y
		return pos_a.x < pos_b.x
	)
	for n in range(bullets.size()):
		print("après ",bullets[n].get_parent().position.y)
		var bullet:BulletController = bullets[n]
		var current_pos = GridManager.find_placeable_cell(bullet.bullet)
		if bullet.has_moved_from_spawn :
			bullet.get_parent().get_node("Line2D").reset()
		bullet.move(current_pos)
		await bullet.bullet.tween.finished if bullet.bullet.tween else get_tree().process_frame
	game_state = STATES.ENNEMI_TURN
	SignalBus.emit_signal("bullets_turn_finished")
	SignalBus.emit_signal("turn_finished")
	await process_ennemy_turn()

func is_player_turn()->bool:
	return game_state == STATES.PLAYER_TURN

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
