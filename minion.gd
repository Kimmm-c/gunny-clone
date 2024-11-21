extends CharacterBody2D

# A minion is spawn from the boss's (its parent) position.
# At the enemy turn, the minion moves closer to the player's position for 2s (minion timer)
# When the minion collides with the player, it attacks the player
# When the minion is hit by a stone, its health reduces by the stone's damage value
# The minion is dead when its health falls to and below 0
# When the minion is dead, it's freed from queue

signal hit_player
@export var damage = 200
@export var health = 3000
@export var speed = 50
const GRAVITY = 300
var is_moving = false
var direction: Vector2

func _ready() -> void:
	add_to_group("minions")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	if is_moving:
		velocity.x = direction.x * speed
	move_and_slide()

func move(target_position: Vector2) -> void:
	direction = (target_position - global_position).normalized()
	is_moving = true

func play_attack_animation() -> void:
	#change sprite to attack (left/right) based on the character position
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	#if collide with player
	if body.name == "player":
	#emit hit_player signal
		hit_player.emit()
		play_attack_animation()
	
	
	#if collide with stone
	#reduce health
	#if health <= 0 after updating, free the node
	elif body.name == "stone":
		health -= body.damage
		if health <= 0:
			queue_free()
