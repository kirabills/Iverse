extends CanvasLayer




func _ready() -> void:
	if OS.get_name() == "Android":
		$Mobile.visible = true
	else:
		$Mobile.visible = false

func _input(event) -> void:
	if event.is_action_pressed("inventory"):
		pass
