extends RigidBody2D

@export var damage = 1000
@export var bullets_per_shot = 1

enum ProjectileState {
	FLYING,
	COLLIDED
}

signal hit(collider_rid, collider_body, stone)

const GRAVITY = Vector2(0, 98.1)
var is_collided = false
var state : ProjectileState
var drag_force: Vector2


func _ready() -> void:
	state = ProjectileState.FLYING
	play_SFX()


func _physics_process(delta: float) -> void:
	if state == ProjectileState.FLYING:
		apply_force(GRAVITY*mass, position)
		apply_force(drag_force, position)
	elif state == ProjectileState.COLLIDED:
		sleeping = true
		freeze = true
		
	play_animation()


func get_flying_angle() -> float:
	return atan2(linear_velocity.y, linear_velocity.x)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	state = ProjectileState.COLLIDED
	play_SFX()
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


func play_SFX() -> void:
	if state == ProjectileState.FLYING:
		$whoosh_SFX.play()
	elif state == ProjectileState.COLLIDED:
		$exploding_SFX.play()
