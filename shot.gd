extends Node2D

signal shoot
@export var shooting_power = 0.0
@export var shooting_angle = 30
var power_is_increasing = true

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("increase_shooting_angle"):
		shooting_angle += 1
	elif Input.is_action_pressed("decrease_shooting_angle"):
		shooting_angle -= 1
	elif Input.is_action_pressed("shoot"):
		if shooting_power == 1.0:
			power_is_increasing = !power_is_increasing
		
		if power_is_increasing:
			shooting_power += 0.1
		else:
			shooting_power -= 0.1
	elif Input.is_action_just_released("shoot"):
		shoot.emit()
			
