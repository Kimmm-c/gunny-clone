extends CharacterBody2D

@export var player_position = Vector2(200, 200)
@export var health = 25000
@export var speed = 50
const GRAVITY = 300
var is_listening = true
var player_state

enum PlayerState {
	ALIVE,
	DEAD
}

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	if is_listening:
		var direction = Vector2.ZERO
	
		if Input.is_action_pressed("player_moves_left"):
			direction.x -= 1
		elif Input.is_action_pressed("player_moves_right"):
			direction.x += 1
	
		velocity.x = direction.x * speed
	
	move_and_slide()

func _ready() -> void:
	player_state = PlayerState.ALIVE
