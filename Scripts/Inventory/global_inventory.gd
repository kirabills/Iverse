extends Node

var inventory: Array


signal inventory_updated
var spawnable_items: Array = [
	{"type": "Consumable", "name": "Berry", "effect": "Health", "texture": preload("res://Assets/Icons/icon31.png")},
	{"type": "Consumable", "name": "Water", "effect": "Stamina", "texture": preload("res://Assets/Icons/icon9.png")},
	{"type": "Consumable", "name": "Mushroom", "effect": "Armor", "texture": preload("res://Assets/Icons/icon32.png")},
	{"type": "Gift", "name": "Gemstone", "effect": "", "texture": preload("res://Assets/Icons/icon21.png")},
]
var player_node: Node = null
var usage_open: bool = false
@onready var inventory_slot_scene: PackedScene = preload("res://Scenes/Prefabs/inventory_slot.tscn")

func _ready() -> void:
	
	inventory.resize(20)


func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and  inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	
func  remove_item(item_type, item_effect) :
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and  inventory[i]["effect"] ==  item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func increase_inventory_size(extra_slot) -> void:
	inventory.resize(inventory.size() + extra_slot)
	inventory_updated.emit()

func set_player_reference(player: Node) -> void:
	player_node = player
	print(player_node)


func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position

func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
