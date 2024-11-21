extends Node2D

@export var stone_scene: PackedScene
var counter = 0

func _ready() -> void:              
	$TurnManager.start_player_turn($Player, $Shot)
	
func _on_stone_hit(collider_rid, collider_body) -> void:
	if collider_body.name == "ground":
		var ground = $tutorial_level/ground
		var tile_coord = collider_body.get_coords_for_body_rid(collider_rid)
		
		ground.erase_cell(tile_coord)
		
		
		#ground.set_cell(tile_coord, -1, Vector2i(-1, -1), -1)

func shoot() -> void:
	$StoneTimer.start()
	

func _on_stone_timer_timeout() -> void:
	# var rand_angle_degree = randf_range(30, 90)
	if counter < 3:
		var rand_angle_rad = deg_to_rad($Shot.shooting_angle)
	
	# Get a random magnitude of the impulse
	# var rand_mag = randi() % 1000 + 200
	
	# Calculate the impulse vector on the angle
		var impulse_vector = Vector2(cos(rand_angle_rad), -sin(rand_angle_rad)) * $Shot.shooting_power * 5000
	
	#instantiate the stone
		var stone = stone_scene.instantiate()
		stone.position = $Player.position
	
	# Apply the impulse on the stone
		stone.apply_central_impulse(impulse_vector)
	
	# add the stone to the screen
		add_child(stone)
		stone.connect("hit", _on_stone_hit)
		counter += 1
	else:
		counter = 0
		$StoneTimer.stop()
		$TurnManager.start_enemy_turn()


func _on_turn_manager_player_timer_timeout() -> void:
	$TurnManager.stop_player_turn($Player, $Shot)
	print("making the shot at _ degree and _ power", $Shot.shooting_angle, $Shot.shooting_power)
	# make the shot
	# $ShotManager.shoot($Player, $Shot)
	shoot()


func _on_turn_manager_enemy_timer_timeout() -> void:
	$TurnManager.start_player_turn($Player, $Shot)
