class_name TimeSystem extends Node

@export var date_time: DateTime
@export var ticks_index: int = 7
@export var ticks_per_seconds_options: Array[int] = [
	2,
	4,
	8,
	 16, 32, 64, 90, 128, 256, 512, 1024, 2048, 4196
	
]

signal updated_time

var is_paused: bool = false

func _process(delta: float) -> void:
	if OS.is_debug_build():
		handle_input()
	if is_paused: return
	
	date_time.increase_by_sec(delta * ticks_per_seconds_options[ticks_index])
	updated_time.emit(date_time)


func handle_input() -> void:
	if Input.is_action_just_pressed("dec_speed"):
		ticks_index -= 1
		
	if Input.is_action_just_pressed("inc_speed"):
		ticks_index += 1
		
	if Input.is_action_just_pressed("pause_time"):
		is_paused = !is_paused
	
	ticks_index = clamp(ticks_index, 0 , ticks_per_seconds_options.size() - 1)
