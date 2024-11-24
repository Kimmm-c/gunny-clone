extends RigidBody2D

@export var damage = 1000
@export var bullets_per_shot = 1


signal hit(collider_rid, collider_body, stone)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	hit.emit(body_rid, body, self)
	#queue_free()


func delete() -> void:
	queue_free()
