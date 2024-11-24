extends RigidBody2D

@export var damage = 1000
@export var bullets_per_shot = 1

#func _physics_process(delta: float) -> void:
	#print(get_contact_count())
signal hit(collider_rid, collider_body)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	hit.emit(body_rid, body)
	queue_free()
