extends CanvasLayer



@onready var inventory = $InventoryGUI

func _ready() -> void:
	inventory._close()
	if OS.get_name() == "Android":
		$ControlesConatainer.visible = true
		$pause.visible = true
		$HotBar.queue_free()
	else:
		$ControlesConatainer.visible = false
		$pause.visible = false
		$HotBarmobileConatainer/HotBarMobile.queue_free()

func _input(event) -> void:
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory._close()
			if inventory.itemInHand:
				inventory.putItemBack()
		else:
			inventory._open()
