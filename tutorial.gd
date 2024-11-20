extends Node2D

@export var stone_scene: PackedScene
var is_player_turn = true

func _physics_process(delta: float) -> void:
	pass
	
func _on_stone_hit(collider_rid, collider_body) -> void:
	if collider_body.name == "ground":
		var ground = $tutorial_level/ground
		var tile_coord = collider_body.get_coords_for_body_rid(collider_rid)
		
		ground.erase_cell(tile_coord)
		
		
		#ground.set_cell(tile_coord, -1, Vector2i(-1, -1), -1)

func shoot() -> void:
	pass
	
func _on_player_timer_timeout() -> void:
	shoot()

func _on_stone_timer_timeout() -> void:
	var rand_angle_degree = randf_range(30, 90)
	var rand_angle_rad = deg_to_rad(rand_angle_degree)
	
	# Get a random magnitude of the impulse
	var rand_mag = randi() % 1000 + 200
	
	# Calculate the impulse vector on the angle
	var impulse_vector = Vector2(cos(rand_angle_rad), -sin(rand_angle_rad)) * rand_mag
	
	#instantiate the stone
	var stone = stone_scene.instantiate()
	stone.position = $character.position
	
	# Apply the impulse on the stone
	stone.apply_central_impulse(impulse_vector)
	
	# add the stone to the screen
	add_child(stone)
	stone.connect("hit", _on_stone_hit)
