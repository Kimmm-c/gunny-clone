extends CharacterBody2D

# 
signal is_dead

enum CharacterState {
	IDLE,
	MOVING,
	ATTACKING,
	DEAD
}

const GRAVITY = 300
const MAX_HEALTH = 30000.0
var state: CharacterState
var health = MAX_HEALTH:
	set(value):
		var damage = health - value
		health = value
		$HealthBar.value -= damage / MAX_HEALTH * 100


func _ready() -> void:
	state = CharacterState.IDLE


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	play_animation()


func play_animation() -> void:
	if state == CharacterState.IDLE:
		$AnimatedSprite2D.play("idle")
	elif state == CharacterState.DEAD:
		$AnimatedSprite2D.play("dead")


func die() -> void:
	print("boss is dead")
	is_dead.emit()
