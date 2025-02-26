extends Node

var inventory: Array


signal inventory_updated

var player_node: Node = null

func _ready() -> void:
	Inventory_g.set_player_reference(self)
	inventory.resize(30)


func add_item() -> void:
	inventory_updated.emit()
	
func  remove_item() -> void:
	inventory_updated.emit()

func increase_inventory_size() -> void:
	inventory_updated.emit()

func set_player_reference(player: Node) -> void:
	player_node = player
