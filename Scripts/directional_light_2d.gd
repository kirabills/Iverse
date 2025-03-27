extends DirectionalLight2D

@export_category("Ciclo dia e noite")
@export var day_color: Color
@export var nigth_color: Color

@export var day_start: DateTime
@export var night_start: DateTime
@export var transition_time: int = 30
@export var time_system: TimeSystem

var in_transition: bool = false

enum DayState {DAY, NIGTH}

var current_state: DayState = DayState.DAY

@onready var time_map: Dictionary = {
	DayState.DAY: day_start,
	DayState.NIGTH: night_start,
}

@onready var transition_map : Dictionary = {
	DayState.DAY: DayState.NIGTH,
	DayState.NIGTH: DayState.DAY
}

@onready var color_map: Dictionary = {
	DayState.DAY: day_color,
	DayState.NIGTH: nigth_color
}


func _ready() -> void:
	var diff_day_start = time_system.date_time.diff_without_days(day_start)
	var diff_nigth_start = time_system.date_time.diff_without_days(night_start)
	
	if diff_day_start < 0 or diff_nigth_start > 0:
		current_state = DayState.NIGTH
	print(diff_day_start)
		

func update(game_time: DateTime) -> void:
	var next_state = transition_map[current_state]
	var change_time = time_map[next_state]
	var time_diff = change_time.diff_without_days(game_time)
	
	if in_transition:
		upadate_transition(time_diff, next_state)
	
	elif time_diff > 0 and time_diff < (transition_time * 60):
		in_transition = true
		upadate_transition(time_diff, next_state)
	else:
		color = color_map[current_state]
		
func upadate_transition(time_diff: int, next_state: DayState) -> void:
	var ratio = 1 - (time_diff as float / (transition_time * 60))
	if ratio > 1:
		current_state = next_state
		in_transition = false
	else:
		color = color_map[current_state].lerp(color_map[next_state], ratio)
