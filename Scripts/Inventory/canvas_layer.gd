extends CanvasLayer




func _ready() -> void:
	if OS.get_name() == "Android":
		$Mobile.visible = true
	else:
		$Mobile.visible = false
