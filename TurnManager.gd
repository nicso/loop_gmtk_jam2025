extends Node
enum STATES {PLAYER_TURN, ENNEMI_TURN}
var game_state : STATES = STATES.PLAYER_TURN
var ennemies = []
var bullets = []
var player : Placeable

func _ready() -> void:
	SignalBus.connect("player_moved", on_player_moved)

func state_to_string()->String:
	match game_state:
		STATES.PLAYER_TURN:
			return "player turn"
		STATES.ENNEMI_TURN:
			return "ennemi turn"
	return "no turn"
	
func on_ennemy_moved()->void:
	pass

func on_player_moved()->void:
	if game_state == STATES.PLAYER_TURN:
		game_state = STATES.ENNEMI_TURN
		SignalBus.emit_signal("turn_finished")
		await process_ennemy_turn()
		
func process_ennemy_turn()->void:
	for ennemy:EnnemyController in ennemies:
		var current_pos = GridManager.find_placeable_cell(ennemy.ennemy)
		ennemy.move(current_pos + Vector2i.DOWN)
		await ennemy.ennemy.tween.finished if ennemy.ennemy.tween else get_tree().process_frame
	
	for n in range(bullets.size()):
		if bullets[n] == null:
			bullets = bullets.filter(func(bullet): bullet!=null)
			break
		var bullet:BulletController = bullets[n]
		var current_pos = GridManager.find_placeable_cell(bullet.bullet)
		bullet.move(current_pos)
		await bullet.bullet.tween.finished if bullet.bullet.tween else get_tree().process_frame
	#for bullet:BulletController in bullets:
		#if bullet == null:
			#break
		#var current_pos = GridManager.find_placeable_cell(bullet.bullet)
		#bullet.move(current_pos)
		#await bullet.bullet.tween.finished if bullet.bullet.tween else get_tree().process_frame
	game_state = STATES.PLAYER_TURN
	SignalBus.emit_signal("turn_finished")
	
func is_player_turn()->bool:
	return game_state == STATES.PLAYER_TURN

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
