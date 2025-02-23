extends CanvasLayer



@onready var inventory = $InventoryGUI

func _ready() -> void:
	inventory._close()
	if OS.get_name() == "Android":
		$Mobile.visible = true
		$HotBar.queue_free()
	else:
		$Mobile.visible = false
		$HotBarMobile.queue_free()

func _input(event) -> void:
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory._close()
			inventory.putItemBack()
		else:
			inventory._open()
