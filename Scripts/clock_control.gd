extends Control

@export var time_text: Label = null
@export var timer: Timer = null

var state: String = ""

func _ready() -> void:
	#diaenoite()
	pass

func _process(_delta: float) -> void:
	time_text.text = "Horas: " + str(_global.hour).pad_zeros(2) + ":" + str(_global.minute).pad_zeros(2)

func _on_timer_timeout() -> void:
	_global.minute += 10
	if _global.minute > 50:
		_global.minute = 0
		_global.hour += 1
		#diaenoite()
		if _global.hour > 23:
			_global.hour = 0
			_global.minute = 0
#
#func diaenoite():
	#
	#if _global.hour >= 6 and _global.hour < 7 and state != "day":
		#_global.dia.play("DIA")
		#state = "day"
		#print(state)
	#elif state != "night" and _global.hour >= 18:
		#_global.dia.play("night")
		#state = "night"
		#print(state)
	
