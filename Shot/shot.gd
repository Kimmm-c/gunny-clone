extends Node2D

signal shoot
const SPRITE_WIDTH = 64

var shooting_power = 0.0
var shooting_angle = 30:
	set(value):
		shooting_angle = value
		redraw()
var origin = Vector2(0.5, 200):
	set(value):
		origin = value
		redraw()
var shooting_direction = Vector2(1, 0):
	set(value):
		shooting_direction = value
		redraw()
var end : Vector2
var power_is_increasing = true

func _ready() -> void:
	calculate_end_point()
	update_progress_bar()


func _physics_process(delta: float) -> void:
	if $FrameCounter.frame_counter: 
		if Input.is_action_pressed("increase_shooting_angle"):
			shooting_angle += 1
		elif Input.is_action_pressed("decrease_shooting_angle"):
			shooting_angle -= 1
		elif Input.is_action_pressed("shoot"):
			if shooting_power > 1.0:
				power_is_increasing = !power_is_increasing
			elif shooting_power < 0:
				power_is_increasing = !power_is_increasing
		
			if power_is_increasing:
				shooting_power += 0.01
			else:
				shooting_power -= 0.01
				
			update_progress_bar()
				
		if Input.is_action_just_released("shoot"):
			shoot.emit()


func update_progress_bar() -> void:
	$ProgressBar.value = shooting_power * 100


func calculate_end_point() -> void:
	var angle_in_rad = deg_to_rad(shooting_angle)
	var new_end = Vector2(cos(angle_in_rad) * SPRITE_WIDTH, sin(angle_in_rad) * SPRITE_WIDTH)
	
	# finalize end point before redrawing
	if shooting_direction.x < 0:
		end.x = (origin.x - new_end.x)
	else:
		end.x = (origin.x + new_end.x)
	end.y = (origin.y - new_end.y)
	print("shooting endpoint: ", end)


func _draw() -> void:
	draw_line(origin, end, Color.BROWN, 1)

func start_listening() -> void:
	reset_shooting_power()
	
	if $FrameCounter.frame_counter:
		$FrameCounter.reset_counter()
	
	$FrameCounter.start()

func stop_listening() -> void:
	$FrameCounter.stop()
	$FrameCounter.reset_counter()


func reset_shooting_power() -> void:
	shooting_power = 0


func _on_player_change_position(new_position) -> void:
	print("moving angle indicator following player's position: ", new_position)
	origin = new_position


func _on_player_change_direction() -> void:
	print("moving angle indicator following player's new direction")
	shooting_direction *= -1


func redraw() -> void:
	calculate_end_point()
	queue_redraw()
