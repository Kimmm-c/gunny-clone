extends CharacterBody2D

signal change_position(new_position)
signal throw
signal is_dead

const MAX_HEALTH = 250
const GRAVITY = 300
var is_listening = true
var prev_position: Vector2
var state: CharacterState
var idle_direction: Vector2
var health = MAX_HEALTH:
	set(value):
		var damage = health - value
		health = value
		$HealthBar.set_value_no_signal($HealthBar.value - damage / MAX_HEALTH * 100)
var speed = 50

enum CharacterState {
	IDLE,
	MOVING,
	ATTACKING
}


func _ready() -> void:
	prev_position = position
	state = CharacterState.IDLE
	idle_direction = Vector2(1, 0)


func _physics_process(delta: float) -> void:
	if position != prev_position:
		change_position.emit(position)
		prev_position = position
	
	velocity.y += GRAVITY * delta
	if is_listening:
		var direction = Vector2(0, 0)
		if Input.is_action_pressed("player_moves_left"):
			direction.x -= 1
		elif Input.is_action_pressed("player_moves_right"):
			direction.x += 1
	
		velocity.x = direction.x * speed
		idle_direction = direction
	move_and_slide()
	play_animation()


func attack() -> void:
	state = CharacterState.ATTACKING


func die() -> void:
	print("player is dead")
	is_dead.emit()
	#optional: play death animation
	
func play_animation() -> void:
	if idle_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	if state == CharacterState.IDLE:
		$AnimatedSprite2D.play("idle")
	elif state == CharacterState.ATTACKING:
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		state = CharacterState.IDLE
		throw.emit()
