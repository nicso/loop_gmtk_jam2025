extends Node
class_name GameManager

enum TurnType { PLAYER, ENEMY, BULLET }

var current_state: GameState
var player_state: PlayerTurnState
var bullet_state: BulletTurnState  
var enemy_state: EnemyTurnState

var bullet_processor: BulletProcessor
var enemy_processor: EnemyProcessor

var ennemies: Array = []
var bullets: Array = []
var player: Placeable

func _ready() -> void:
	setup_states()
	setup_processors()
	setup_signals()
	start_game()

func setup_states() -> void:
	player_state = PlayerTurnState.new(self)
	bullet_state = BulletTurnState.new(self)
	enemy_state = EnemyTurnState.new(self)

func setup_processors() -> void:
	bullet_processor = BulletProcessor.new(self)
	enemy_processor = EnemyProcessor.new(self)

func setup_signals() -> void:
	SignalBus.connect("player_turn_finished", _on_player_action_completed)

func start_game() -> void:
	change_state(player_state)

class GameState:
	var manager: GameManager	
	func _init(game_manager: GameManager):
		manager = game_manager
	func enter() -> void:
		pass
	func execute() -> void:
		pass
	func exit() -> void:
		pass
	func get_name() -> String:
		return "Unknown"

class PlayerTurnState extends GameState:
	func get_name() -> String:
		return "Player Turn"
	
	func enter() -> void:
		SignalBus.emit_signal("turn_changed", TurnType.PLAYER)
		print("state --- ", get_name())
	
	func execute() -> void:
		await SignalBus.player_turn_finished
		manager.change_state(manager.bullet_state)

class BulletTurnState extends GameState:
	func get_name() -> String:
		return "Bullet Turn"
	
	func enter() -> void:
		SignalBus.emit_signal("turn_changed", TurnType.BULLET)
		print("state --- ", get_name())
	
	func execute() -> void:
		await manager.bullet_processor.process_turn()
		manager.change_state(manager.enemy_state)

class EnemyTurnState extends GameState:
	func get_name() -> String:
		return "Enemy Turn"
	
	func enter() -> void:
		SignalBus.emit_signal("turn_changed", TurnType.ENEMY)
		print("state --- ", get_name())
	
	func execute() -> void:
		await manager.enemy_processor.process_turn()
		manager.change_state(manager.player_state)


class EntityProcessor:
	var manager: GameManager
	
	func _init(game_manager: GameManager):
		manager = game_manager
	
	func process_turn() -> void:
		pass

class BulletProcessor extends EntityProcessor:
	func process_turn() -> void:
		var valid_bullets = get_valid_entities(manager.bullets)
		if valid_bullets.is_empty():
			return
		
		var sorted_bullets = sort_by_position(valid_bullets)
		await move_entities(sorted_bullets)
	
	func get_valid_entities(entities: Array) -> Array:
		return entities.filter(func(bullet): 
			return bullet != null and is_instance_valid(bullet) and is_instance_valid(bullet.bullet)
		)
	
	func sort_by_position(bullets: Array) -> Array:
		var sorted = bullets.duplicate()
		sorted.sort_custom(func(a, b):
			var pos_a = GridManager.find_placeable_cell(a.bullet)
			var pos_b = GridManager.find_placeable_cell(b.bullet)
			return pos_a.y < pos_b.y or (pos_a.y == pos_b.y and pos_a.x < pos_b.x)
		)
		return sorted
	
	func move_entities(bullets: Array) -> void:
		for bullet in bullets:
			var current_pos = GridManager.find_placeable_cell(bullet.bullet)
			
			if bullet.has_moved_from_spawn:
				reset_trail(bullet)
			
			bullet.move(current_pos)
			await wait_for_movement(bullet.bullet)

	func reset_trail(bullet) -> void:
		var line_node = bullet.get_parent().get_node_or_null("Line2D")
		if line_node:
			line_node.reset()
	
	func wait_for_movement(entity) -> void:
		if entity.tween:
			await entity.tween.finished
		else:
			await manager.get_tree().process_frame

class EnemyProcessor extends EntityProcessor:
	func process_turn() -> void:
		var valid_enemies = get_valid_entities(manager.ennemies)
		if valid_enemies.is_empty():
			return
		
		await move_entities(valid_enemies)
	
	func get_valid_entities(entities: Array) -> Array:
		return entities.filter(func(enemy): 
			return enemy != null and is_instance_valid(enemy) and is_instance_valid(enemy.ennemy)
		)
	
	func move_entities(enemies: Array) -> void:
		for enemy in enemies:
			var current_pos = GridManager.find_placeable_cell(enemy.ennemy)
			enemy.move(current_pos + Vector2i.DOWN)
			await wait_for_movement(enemy.ennemy)
	
	func wait_for_movement(entity) -> void:
		if entity.tween:
			await entity.tween.finished
		else:
			await manager.get_tree().process_frame


func change_state(new_state: GameState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	current_state.execute()

func _on_player_action_completed() -> void:
	# Le signal est géré automatiquement par l'état actuel
	pass

func is_player_turn() -> bool:
	return current_state is PlayerTurnState

func get_current_turn_name() -> String:
	return current_state.get_name() if current_state else "No Turn"

func add_enemy(enemy) -> void:
	ennemies.append(enemy)

func add_bullet(bullet) -> void:
	bullets.append(bullet)

func remove_enemy(enemy) -> void:
	ennemies.erase(enemy)

func remove_bullet(bullet) -> void:
	bullets.erase(bullet)
