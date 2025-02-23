extends CanvasLayer



@onready var inventory = $InventoryGUI

func _ready() -> void:
	inventory._close()
	if OS.get_name() == "Android":
		$Mobile.visible = true
	else:
		$Mobile.visible = false

func _input(event) -> void:
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory._close()
		else:
			inventory._open()
