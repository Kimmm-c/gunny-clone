extends RigidBody2D

@export var damage = 5
@export var bullets_per_shot = 1

enum ProjectileState {
	FLYING,
	COLLIDED
}

signal hit(collider_rid, collider_body, stone)

var is_collided = false
var state : ProjectileState


func _ready() -> void:
	state = ProjectileState.FLYING


func _physics_process(delta: float) -> void:
	play_animation()


func get_flying_angle() -> float:
	return atan2(linear_velocity.y, linear_velocity.x)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	state = ProjectileState.COLLIDED
	hit.emit(body_rid, body, self)


func _on_animated_sprite_2d_animation_finished() -> void:
	if state == ProjectileState.COLLIDED:
		queue_free()


func play_animation() -> void:
	if state == ProjectileState.FLYING:
		$AnimatedSprite2D.rotation = get_flying_angle()
		$AnimatedSprite2D.play("flying")
	else:
		$AnimatedSprite2D.play("blowing")
