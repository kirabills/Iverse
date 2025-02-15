extends Resource
class_name Inventory


@export var items: Array[InventoryItem]
signal updated 

func insert(item: InventoryItem) -> void:
	for i in range(items.size()):
		if !items[i] : 
			items[i] = item
			break
	updated.emit()
