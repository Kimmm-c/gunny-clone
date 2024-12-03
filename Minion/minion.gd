extends CharacterBody2D

# A minion is spawn from the boss's (its parent) position.
# At the enemy turn, the minion moves closer to the player's position for 2s (minion timer)
# When the minion collides with the player, it attacks the player
# When the minion is hit by a stone, its health reduces by the stone's damage value
# The minion is dead when its health falls to and below 0
# When the minion is dead, it's freed from queue

signal hit_player(damage)
@export var damage = 200
@export var health = 3000
@export var speed = 50
const GRAVITY = 300
#var is_moving = false
var direction: Vector2
var state = MinionState.IDLE

enum MinionState {
	IDLE,
	MOVING,
	ATTACKING
}

func _ready() -> void:
	add_to_group("minions")


func _physics_process(delta: float) -> void:	
	velocity.y += GRAVITY * delta
	if state == MinionState.MOVING:
		velocity.x = direction.x * speed
		
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.name == "Player" and $FrameCounter.frame_counter % 60 == 0:
			attack()
		elif collider.name == "Stone":
			health -= collider.damage
	
	play_animation()

func move(target_position: Vector2) -> void:
	if $FrameCounter.frame_counter:
		$FrameCounter.reset_counter()
		
	$FrameCounter.start()
	direction = (target_position - global_position).normalized()
	state = MinionState.MOVING


func stop() -> void:
	state = MinionState.IDLE
	velocity = Vector2.ZERO
	$FrameCounter.stop()
	$FrameCounter.reset_counter()


func attack() -> void:
	state = MinionState.ATTACKING
	hit_player.emit(damage)


func play_animation() -> void:
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	if state == MinionState.IDLE:
		$AnimatedSprite2D.play("idle")
	elif state == MinionState.MOVING:
		$AnimatedSprite2D.play("walk")
	elif state == MinionState.ATTACKING:
		$AnimatedSprite2D.play("attack")


func die() -> void:
	print("minion is exiting the scene...")
	queue_free()
