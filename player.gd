extends CharacterBody2D

@export var player_position = Vector2(200, 200)
@export var health = 25000
var player_state

enum PlayerState {
	ALIVE,
	DEAD
}

func _ready() -> void:
	player_state = PlayerState.ALIVE
