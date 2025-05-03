extends Control

@onready var days_label: Label = $DayControl/days
@onready var hours_label: Label = $ClockBG/ClockControl/hours
@onready var minutes_label: Label = $ClockBG/ClockControl/minutes

func _ready() -> void:
	TimeSystems.updated_time.connect(_on_time_system_updated_time)


func _on_time_system_updated_time(date_time: DateTime) -> void:
	days_label.text = str(date_time.days).pad_zeros(2)
	hours_label.text = str(date_time.hours).pad_zeros(2)
	minutes_label.text = str(date_time.minutes).pad_zeros(2)
	
	_global.save_dict.day = date_time.days
	_global.save_dict.hour = date_time.hours
	_global.save_dict.minute = date_time.minutes
	_global.save_dict.seconds = date_time.seconds
