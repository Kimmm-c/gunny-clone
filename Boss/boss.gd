extends RigidBody2D

# 
signal boss_is_dead
@export var minions_per_spawn = 3
@export var health = 25000

enum CharacterState {
	IDLE,
	MOVING,
	ATTACKING,
	DEAD
}

var state: CharacterState


func _ready() -> void:
	state = CharacterState.IDLE


func _physics_process(delta: float) -> void:
	if health <= 0:
		boss_is_dead.emit()
		
	play_animation()


func play_animation() -> void:
	if state == CharacterState.IDLE:
		$AnimatedSprite2D.play("idle")
	elif state == CharacterState.DEAD:
		$AnimatedSprite2D.play("dead")
