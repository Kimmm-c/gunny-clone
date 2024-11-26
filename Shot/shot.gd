extends Node2D

signal shoot
@export var shooting_power = 0.0
@export var shooting_angle = 30:
	set(value):
		shooting_angle = value
		calculate_end_point()
		queue_redraw()

const SPRITE_WIDTH = 64
var origin = Vector2(0.5, 200):
	set(value):
		origin = value
		calculate_end_point()
		queue_redraw()
var end : Vector2
var power_is_increasing = true


func _ready() -> void:
	calculate_end_point()


func _physics_process(delta: float) -> void:
	if $FrameCounter.frame_counter: 
		if $FrameCounter.frame_counter % 20 == 0:
			if Input.is_action_pressed("increase_shooting_angle"):
				shooting_angle += 3
				print("shooting angle: ", shooting_angle)
			elif Input.is_action_pressed("decrease_shooting_angle"):
				shooting_angle -= 3
				print("shooting angle: ", shooting_angle)
			elif Input.is_action_pressed("shoot"):
				if shooting_power > 1.0:
					power_is_increasing = !power_is_increasing
				elif shooting_power < 0:
					power_is_increasing = !power_is_increasing
		
				if power_is_increasing:
					shooting_power += 0.1
				else:
					shooting_power -= 0.1
			
				print("shooting power: ", shooting_power)
		if Input.is_action_just_released("shoot"):
			shoot.emit()


func calculate_end_point() -> void:
	var angle_in_rad = deg_to_rad(shooting_angle)
	var new_end = Vector2(cos(angle_in_rad) * SPRITE_WIDTH, sin(angle_in_rad) * SPRITE_WIDTH)
	
	# finalize end point before redrawing
	end.x = (origin.x + new_end.x)
	end.y = (origin.y - new_end.y)


func _draw() -> void:
	draw_line(origin, end, Color.BROWN, 1)

func start_listening() -> void:
	if $FrameCounter.frame_counter:
		$FrameCounter.reset_counter()
	
	$FrameCounter.start()

func stop_listening() -> void:
	$FrameCounter.stop()
	$FrameCounter.reset_counter()


func reset_shooting_power() -> void:
	shooting_power = 0


func _on_player_change_position(new_position) -> void:
	origin = new_position
