extends Control
signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://Scripts/Inventory/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	inventory.updated.connect(update)
	update()

func update() -> void:
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i]._update(inventory.items[i])

func _open() -> void:
	visible = true
	isOpen = true
	opened.emit()
	
func _close() -> void:
	visible = false
	isOpen = false
	closed.emit()
