extends RigidBody2D

signal boss_is_dead
@export var minions_per_spawn = 3
@export var health = 25000

func spawn_minions():
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	#if collide with stone
	#reduce health
	#if health <= 0 after updating, emit boss_is_dead signal
	pass # Replace with function body.
