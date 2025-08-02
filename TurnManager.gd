extends Node
enum STATES {PLAYER_TURN, ENNEMI_TURN}
var game_state : STATES = STATES.PLAYER_TURN
var ennemies = []
var bullets = []
func _ready() -> void:
	SignalBus.connect("player_moved", on_player_moved)

func state_to_string()->String:
	match game_state:
		STATES.PLAYER_TURN:
			return "player turn"
		STATES.ENNEMI_TURN:
			return "ennemi turn"
	return "no turn"
	
func on_ennemy_moved():
	pass

func on_player_moved():
	if game_state == STATES.PLAYER_TURN:
		game_state = STATES.ENNEMI_TURN
		await process_ennemy_turn()
		
func process_ennemy_turn():
	# Déplacer tous les ennemis
	for ennemy in ennemies:
		var current_pos = GridManager.find_placeable_cell(ennemy.ennemy)
		ennemy.move(current_pos + Vector2i.DOWN)
		# Attendre que chaque ennemi finisse son mouvement
		await ennemy.ennemy.tween.finished if ennemy.ennemy.tween else get_tree().process_frame
	
	# Déplacer toutes les balles
	for bullet in bullets:
		var current_pos = GridManager.find_placeable_cell(bullet.bullet)
		bullet.move(current_pos)
		# Attendre que chaque balle finisse son mouvement
		await bullet.bullet.tween.finished if bullet.bullet.tween else get_tree().process_frame
	
	# Retourner au tour du joueur une fois que tout est fini
	game_state = STATES.PLAYER_TURN
	
func is_player_turn()->bool:
	return game_state == STATES.PLAYER_TURN

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
