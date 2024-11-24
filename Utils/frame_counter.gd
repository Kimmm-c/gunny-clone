extends Node

var frame_counter = 0
var is_counting = false

func _physics_process(delta: float) -> void:
	if is_counting:
		frame_counter += 1


func reset_counter() -> void:
	frame_counter = 0


func start() -> void:
	is_counting = true


func stop() -> void:
	is_counting = false
