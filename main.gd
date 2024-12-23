extends Node

@export var singleplayer_game_scene: PackedScene
@export var multiplayer_game_scene: PackedScene
@export var address = "127.0.0.1"
var peer: ENetMultiplayerPeer
var port = 9999
var max_clients = 2 # 2 players


func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func peer_connected(id: int):
	print("player connected. id: ", id)


func peer_disconnected(id: int):
	print("player disconnected. id: ", id)


func connected_to_server():
	print("successfully connected to the server")
	# When client connects to the server, send client/player's info to the server
	# Note: 1 is the server's id. This statement instructs the server to execute its send_player_info function.
	send_player_info.rpc_id(1, $UI/LineEdit.text, multiplayer.get_unique_id())


func connection_failed():
	print("connection failed")


func _on_host_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_clients)
	if error != OK:
		print("hosting failed. error: ", error)
		return
	multiplayer.multiplayer_peer = peer
	send_player_info($UI/LineEdit, multiplayer.get_unique_id())
	print("waiting for players...")


func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error != OK:
		print("creating client failed. error: ", error)
		return
	multiplayer.multiplayer_peer = peer


func _on_start_game_pressed() -> void:
	start_multiplayer_game.rpc()


@rpc("any_peer", "call_local")
func start_multiplayer_game():
	$UI.hide()
	var multiplayer_game = multiplayer_game_scene.instantiate()
	add_child(multiplayer_game)
	#multiplayer_game.game_end.connect(_on_game_end.bind())


@rpc("any_peer")
func send_player_info(name, id):
	# The server checks if the id has already existed in GameManager.Players dict.
	# If not, add the player and their info to the list.
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"id": id,
			"name": name
		}
	
	# To ensure all the peers have up-to-date info about all the players,
	# the server loops through each player in the list and call send_player_info on each of them
	# This guarantees each player receives a full list of players once they join the server. (Because
	# each multiplayer client has their own GameManager.Players list).
	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_info.rpc(GameManager.Players[i].name, i)


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
