extends Node2D

@export var stone_scene: PackedScene
@export var minion_scene: PackedScene
var stone_counter = 0
var enemy_turn_counter = 0

func _ready() -> void:              
	#$TurnManager.start_player_turn($Player, $Shot)
	$TurnManager.start_enemy_turn()
	start_enemy_turn()
	
func _on_stone_hit(collider_rid, collider_body) -> void:
	if collider_body.name == "ground":
		var ground = $tutorial_level/ground
		var tile_coord = collider_body.get_coords_for_body_rid(collider_rid)
		
		ground.erase_cell(tile_coord)


func shoot() -> void:
	$StoneTimer.start()
	

func _on_stone_timer_timeout() -> void:
	if stone_counter < 3:
		var shooting_angle_rad = deg_to_rad($Shot.shooting_angle)
	
	# Calculate the impulse vector on the angle
		var impulse_vector = Vector2(cos(shooting_angle_rad), -sin(shooting_angle_rad)) * $Shot.shooting_power * 2000
	
	#instantiate the stone
		var stone = stone_scene.instantiate()
		stone.position = $Player.position
	
	# Apply the impulse on the stone
		stone.apply_central_impulse(impulse_vector)
	
	# add the stone to the screen
		add_child(stone)
		stone.connect("hit", _on_stone_hit)
		stone_counter += 1
	else:
		stone_counter = 0
		$StoneTimer.stop()
		$TurnManager.start_enemy_turn()
		start_enemy_turn()
		$Shot.reset_shooting_power()

func start_enemy_turn() -> void:
	if enemy_turn_counter % 3 == 0:
		spawn_the_minions()
	else:
		move_the_minions()
	enemy_turn_counter += 1

func spawn_the_minions() -> void:
	print("spawning the minions...")
	var spawn_position = $Boss.position
	for i in range(3):
		print("spawning enemy ", i)
		var minion = minion_scene.instantiate()
		minion.position = spawn_position
		add_child(minion)
		spawn_position.x += 25

func move_the_minions() -> void:
	print("minions are moving...")
	get_tree().call_group("minions", "move", $Player.position)

func _on_turn_manager_player_timer_timeout() -> void:
	$TurnManager.stop_player_turn($Player, $Shot)
	shoot()


func _on_turn_manager_enemy_timer_timeout() -> void:
	#$TurnManager.start_player_turn($Player, $Shot)
	$TurnManager.start_enemy_turn()
	start_enemy_turn()
