#ui inventory.gd
extends Control
@onready var grid_container = $GridContainer


func _ready() -> void:
	Inventory_g.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	
		
	
func _on_inventory_updated():
	clear_grid_container()
	
	for item in Inventory_g.inventory:
		var slot = Inventory_g.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
		
