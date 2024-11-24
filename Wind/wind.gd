extends Node2D

@export var wind_direction = Vector2(1, 0)
@export var wind_intensity = 200


func rand_direction() -> Vector2:
	var directions = [Vector2(1, 0), Vector2(-1, 0)]
	return directions[randi_range(0, 1)]

func rand_intensity() -> int:
	return randi() % 300 + 50
