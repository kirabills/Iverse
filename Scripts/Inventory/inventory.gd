extends Resource
class_name Inventory


@export var slots: Array[InventorySlot]
signal updated 

func insert(item: InventoryItem) -> void:
	var itemSlots = slots.filter(func(slot): return slot.item == item && slot.amount < slot.item.max_amount)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	updated.emit()

func removeAtIndex(index: int):
	slots[index] = InventorySlot.new()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldIndex: int = slots.find(inventorySlot)
	removeAtIndex(oldIndex)
	
	slots[index] = inventorySlot
