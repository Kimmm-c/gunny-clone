extends Node2D

@export var stone_scene: PackedScene
@export var minion_scene: PackedScene
const MINION_GROUP = "minions"
const HIT_PLAYER_SIGNAL = "hit_player"
var stone_counter = 0
var enemy_turn_counter = 0

func _ready() -> void:       
	start_player_turn()       
	#start_enemy_turn()


func start_player_turn() -> void:
	print("starting player's turn...")
	$Player.is_listening = true
	$Shot.is_listening = true
	$PlayerTimer.start()


func _on_hit_player(damage) -> void:
	$Player.health -= damage
	print("player is under attack! Remaining health: ", $Player.health)


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
		var impulse_vector = Vector2(cos(shooting_angle_rad), -sin(shooting_angle_rad)) * $Shot.shooting_power * 3000
	
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
		start_enemy_turn()
		#$TurnManager.start_enemy_turn()
		start_enemy_turn()
		$Shot.reset_shooting_power()


func start_enemy_turn() -> void:
	print("starting enemy's turn...")
	$MinionTimer.start()
	
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
		minion.hit_player.connect(_on_hit_player.bind())
		spawn_position.x += 25


func move_the_minions() -> void:
	print("minions are moving...")
	get_tree().call_group(MINION_GROUP, "move", $Player.position)


func stop_player_turn() -> void:
	print("stopping player's turn...")
	$Player.is_listening = false
	$Shot.is_listening = false
	$PlayerTimer.stop()


func _on_player_timer_timeout() -> void:
	stop_player_turn()
	shoot()


func _on_minion_timer_timeout() -> void:
	get_tree().call_group(MINION_GROUP, "stop")
	start_player_turn()
