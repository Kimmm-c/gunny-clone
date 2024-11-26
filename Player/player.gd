extends CharacterBody2D

@export var health = 25000
@export var speed = 50

signal change_position(new_position)

const GRAVITY = 300
var is_listening = true
var prev_position: Vector2

func _ready() -> void:
	prev_position = position


func _physics_process(delta: float) -> void:
	if position != prev_position:
		change_position.emit(position)
		prev_position = position
	
	velocity.y += GRAVITY * delta
	if is_listening:
		var direction = Vector2.ZERO
	
		if Input.is_action_pressed("player_moves_left"):
			direction.x -= 1
		elif Input.is_action_pressed("player_moves_right"):
			direction.x += 1
	
		velocity.x = direction.x * speed
	
	move_and_slide()
