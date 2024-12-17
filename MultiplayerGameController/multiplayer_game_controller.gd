extends Node2D

@export var player_scene: PackedScene

enum PlayerTurn {
	PLAYER1,
	PLAYER2
}

var player_turn = PlayerTurn.PLAYER1

func _ready() -> void:
	var index = 0
	# spawn players
	for i in GameManager.Players:
		var locations = get_tree().get_nodes_in_group("PlayerSpawnLocations")
		for loc in locations:
			if loc.name == str(index): 
				var player = player_scene.instantiate()
				player.name = str(GameManager.Players[i].id)
				player.position = loc.global_position
				add_child(player)
		index += 1
		
	# spawn shot for the corresponding instance
	# this shot is controllable by a specific player
	
	
	# spawn the wind. This wind's properties should be applied to the shot 
	# of the designated player.
	


func _on_turn_timer_timeout() -> void:
	pass # Replace with function body.
