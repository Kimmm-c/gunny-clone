extends Node2D

@export var wind_direction: Vector2
@export var wind_intensity: int

enum WindIntensity {
	LOW = 100,
	MID = 200,
	HIGH = 300
}

enum WindDirection {
	LEFT,
	RIGHT
}

var intensity_enum_size = WindIntensity.size()
var direction_enum_size = WindDirection.size()
var prev_direction: Vector2


func _ready() -> void:
	update_wind()


func _process(delta: float) -> void:
	if $AnimatedSprite2D.visible:
		update_sprite()


func update_wind() -> void:
	rand_direction()
	rand_intensity()
	print("direction: ", wind_direction)
	print("intensity: ", wind_intensity)


func update_sprite() -> void:
	if wind_intensity == WindIntensity.LOW:
		$AnimatedSprite2D.animation = "low"
	elif wind_intensity == WindIntensity.MID:
		$AnimatedSprite2D.animation = "mid"
	elif wind_intensity == WindIntensity.HIGH:
		$AnimatedSprite2D.animation = "high"

	if wind_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func rand_direction() -> void:
	var rand_key = WindDirection.keys()[randi() % direction_enum_size]
	prev_direction = wind_direction
	if WindDirection.get(rand_key) == WindDirection.LEFT:
		wind_direction = Vector2(-1, 0)
	elif WindDirection.get(rand_key) == WindDirection.RIGHT:
		wind_direction = Vector2(1, 0)


func rand_intensity() -> void:
	var rand_key = WindIntensity.keys()[randi() % intensity_enum_size]
	wind_intensity = WindIntensity.get(rand_key)
