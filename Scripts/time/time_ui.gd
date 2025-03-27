extends Control

@onready var days_label: Label = $DayControl/days
@onready var hours_label: Label = $ClockBG/ClockControl/hours
@onready var minutes_label: Label = $ClockBG/ClockControl/minutes



func _on_time_system_updated_time(date_time: DateTime) -> void:
	days_label.text = str(date_time.days).pad_zeros(2)
	hours_label.text = str(date_time.hours).pad_zeros(2)
	minutes_label.text = str(date_time.minutes).pad_zeros(2)
