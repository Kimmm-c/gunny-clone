extends Node

@export var singleplayer_game_scene: PackedScene
@export var multiplayer_game_scene: PackedScene


func _on_singleplayer_mode_btn_pressed() -> void:
	$UI.hide()
	var singleplayer_game = singleplayer_game_scene.instantiate()
	add_child(singleplayer_game)
	singleplayer_game.game_end.connect(_on_game_end.bind())


func _on_mulptiplayer_mode_btn_pressed() -> void:
	$UI.hide()
	var multiplayer_game = multiplayer_game_scene.instantiate()
	add_child(multiplayer_game)
	multiplayer_game.game_end.connect(_on_game_end.bind())


func _on_exit_btn_pressed() -> void:
	get_tree().quit()


func _on_game_end() -> void:
	print("game has ended, redirecting to main menu...")
	$UI.show()
