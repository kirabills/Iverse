extends Control
@onready var hotbar_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	Inventory_g.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(Inventory_g.hotbar_size):
		var slot = Inventory_g.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		slot.isHotbar = true
		hotbar_container.add_child(slot)
		if Inventory_g.hotbar[i] != null:
			slot.set_item(Inventory_g.hotbar[i])
		else:
			slot.set_empty()
		slot.update_assigment_status()

func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
