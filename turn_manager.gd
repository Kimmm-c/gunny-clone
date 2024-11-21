extends Node

# On game start, start the player's turn (enable player's input listening)
# On player_timer end or on shoot signal, end player's turn (disable user input listening)
# On the last bullet is freed, start the enemy's turn (start enemy's timer)
# On the enemy_timer ends, start the player's turn

signal player_timer_timeout
signal enemy_timer_timeout

func start_player_turn(player, shot) -> void:
	print("starting player's turn...")
	player.is_listening = true
	shot.is_listening = true
	$PlayerTimer.start()

func stop_player_turn(player, shot) -> void:
	print("stopping player's turn...")
	player.is_listening = false
	shot.is_listening = false
	$PlayerTimer.stop()

func start_enemy_turn() -> void:
	print("starting enemy's turn...")
	$EnemyTimer.start()

func _on_player_timer_timeout() -> void:
	player_timer_timeout.emit()

func _on_enemy_timer_timeout() -> void:
	enemy_timer_timeout.emit()
