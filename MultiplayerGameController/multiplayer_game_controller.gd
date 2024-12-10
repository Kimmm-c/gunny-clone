extends Node2D

@export var player_scene: PackedScene

func _ready() -> void:
	var index = 0
	for i in GameManager.Players:
		var locations = get_tree().get_nodes_in_group("PlayerSpawnLocations")
		for loc in locations:
			if loc.name == str(index): 
				var player = player_scene.instantiate()
				player.position = loc.global_position
				add_child(player)
		index += 1
		
