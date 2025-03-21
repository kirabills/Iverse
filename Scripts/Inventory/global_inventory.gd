extends Node

var inventory: Array


signal inventory_updated

var spawnable_items: Array[PackedScene] = [
	load("res://Scenes/Prefabs/items/milk.tscn"),
	load("res://Scenes/Prefabs/items/potion.tscn"),
	load("res://Scenes/Prefabs/items/elixir.tscn"),
	load("res://Scenes/Prefabs/items/elixir_de_mana.tscn"),
	load("res://Scenes/Prefabs/items/cura_tudo.tscn")
]

var player_node: Node = null
var usage_open: bool = false
@onready var inventory_slot_scene: PackedScene = preload("res://Scenes/Prefabs/inventory_slot.tscn")

var hotbar_size: int = 5
var hotbar: Array

func _ready() -> void:
	
	inventory.resize(20)
	hotbar.resize(hotbar_size)


func add_item(item, to_hotbar = false):
	var added_to_hot_bar = false
	
	# Adiciona à hotbar, se necessário
	if to_hotbar:
		added_to_hot_bar = add_hotbar_item(item)
		Inventory_g.inventory_updated.emit()
	
	# Se não foi adicionado à hotbar, tenta adicionar ao inventário
	if not added_to_hot_bar:
		# Primeiro, verifica se já existe um slot com o mesmo tipo e efeito
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
		
		# Se não encontrou um slot com o mesmo tipo e efeito, procura o primeiro slot vazio
		for i in range(inventory.size()):
			if inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				return true
	
	# Se não conseguiu adicionar em nenhum slot, retorna false
	return false
	
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
	
#adiciona o item a hot bar
func add_hotbar_item(item):
	for i in range(hotbar.size()):
		if hotbar[i] == null:
			hotbar[i] = item
			return true
	return false

#remove o item da hotbar
func remove_hotbar_item(item_type, item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			if hotbar[i]["quantity"] <= 0:
				hotbar[i] = null
			inventory_updated.emit()
			return true
	return false

#coloca o item de volta ao inventario
func unnassign_hotbar_item(item_type, item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			hotbar[i] = null
			inventory_updated.emit()
			return true
	return false

#previne duplicatas item de atalho
func is_item_assign_to_hotbar(item_to_check):
	return item_to_check in hotbar
	
func swap_inventory_item(index1, index2):
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
		
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
func swap_hotbar_item(index1, index2):
	if index1 < 0 or index1 > hotbar.size() or index2 < 0 or index2 > hotbar.size():
		return false
		
	var temp = hotbar[index1]
	hotbar[index1] = hotbar[index2]
	hotbar[index2] = temp
	inventory_updated.emit()
	return true
