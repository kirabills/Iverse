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


# Caminho do arquivo de salvamento
const SAVE_FILE_PATH = "user://inventory_save.dat"

# Salva o inventário e a hotbar
func save_inventory():
	var data = {
		"inventory": inventory,
		"hotbar": []
	}

	# Salva os índices dos itens na hotbar
	for i in range(hotbar.size()):
		if hotbar[i] != null:
			data["hotbar"].append(inventory.find(hotbar[i]))  # Salva o índice do item no inventário
		else:
			data["hotbar"].append(null)  # Slot vazio

	var file = FileAccess.open("user://inventory_save.dat", FileAccess.WRITE)

	if file:
		file.store_var(data)
		file.close()
		print("Inventário salvo com sucesso!")
	else:
		print("Erro ao salvar o inventário.")

# Carrega o inventário e a hotbar
func load_inventory():
	if FileAccess.file_exists("user://inventory_save.dat"):
		var file = FileAccess.open("user://inventory_save.dat", FileAccess.READ)
		if file:
			var data = file.get_var()
			file.close()

			if data.has("inventory"):
				inventory = data["inventory"]
				# Restaura as referências aos itens no inventário
				for i in range(inventory.size()):
					if inventory[i] != null and inventory[i].has("scene_path"):
						var scene_path = inventory[i]["scene_path"]
						inventory[i]["scene"] = load(scene_path)

			if data.has("hotbar"):
				hotbar.clear()
				for i in range(data["hotbar"].size()):
					var item_index = data["hotbar"][i]
					if item_index != null and item_index < inventory.size() and inventory[item_index] != null:
						# Verifica se o item está atribuído à hotbar
						if inventory[item_index].has("isAssingned") and inventory[item_index]["isAssingned"] == true:
							hotbar.append(inventory[item_index])  # Adiciona o item à hotbar
						else:
							hotbar.append(null)  # Slot vazio
					else:
						hotbar.append(null)  # Slot vazio

			print("Inventário carregado com sucesso!")
			inventory_updated.emit()
		else:
			print("Erro ao carregar o inventário.")
	else:
		print("Arquivo de salvamento não encontrado. Criando novo inventário.")

func _ready() -> void:
	
	inventory.resize(20)
	hotbar.resize(hotbar_size)
	inventory_updated.emit()

func add_item_from_scene(item_scene: PackedScene, quantity: int = 1, to_hotbar: bool = false):
	# Instancia o item temporariamente para pegar seus dados
	var item_instance = item_scene.instantiate()
	
	# Verifica se o nó tem um script com os dados do item
	if item_instance.has_method("get_item_data"):
		var item_data = item_instance.get_item_data()
		item_data["quantity"] = quantity
		# Adiciona ao inventário
		add_item(item_data, to_hotbar)
	
		item_instance.queue_free()  # Remove a instância temporária
	else:
		print("Erro: O item não tem um método 'get_item_data()'.")
		item_instance.queue_free()
		return false

func add_item(item, to_hotbar = false):
	var added_to_hot_bar = false
	
	# Adiciona à hotbar, se necessário
	if to_hotbar:
		added_to_hot_bar = add_hotbar_item(item)
		inventory_updated.emit()
	
	# Se não foi adicionado à hotbar, tenta adicionar ao inventário
	if not added_to_hot_bar:
		# Primeiro, verifica se já existe um slot com o mesmo tipo e efeito que pode ser empilhado
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				var max_amount = inventory[i]["amount"]
				var total_amount = inventory[i]["quantity"] + item["quantity"]
				
				# Se o slot já está cheio, continua procurando
				if inventory[i]["quantity"] >= max_amount:
					continue
				
				# Se a soma cabe totalmente no slot existente
				if total_amount <= max_amount:
					inventory[i]["quantity"] = total_amount
					inventory_updated.emit()
					return true
				# Se excede a capacidade máxima
				else:
					# Enche o slot atual até o máximo
					var remaining = total_amount - max_amount
					inventory[i]["quantity"] = max_amount
					item["quantity"] = remaining
					# Continua tentando adicionar o restante (recursivamente)
					return add_item(item, to_hotbar)
		
		# Se não encontrou um slot para empilhar, procura o primeiro slot vazio
		for i in range(inventory.size()):
			if inventory[i] == null:
				# Verifica se a quantidade não excede o máximo
				if item["quantity"] > item["amount"]:
					var new_item = item.duplicate()  # Cria uma cópia para não modificar o original
					new_item["quantity"] = item["amount"]
					inventory[i] = new_item
					item["quantity"] -= item["amount"]
					inventory_updated.emit()
					# Tenta adicionar o restante
					return add_item(item, to_hotbar)
				else:
					inventory[i] = item
					inventory_updated.emit()
					return true
	
	# Se não conseguiu adicionar em nenhum slot, retorna false
	return false
	


func  remove_item(item_type, item_effect) :
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and  inventory[i]["effect"] ==  item_effect:
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
				return
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			#save_inventory()	
			inventory_updated.emit()
			return true
	return false

func remove_specific_item(item_to_remove: Dictionary) -> bool:
	for i in range(inventory.size()):
		var item = inventory[i]
		
		# Verifica se é exatamente o mesmo item (comparando referência)
		if item == item_to_remove:
			item["quantity"] -= 1
			
			if item["quantity"] <= 0:
				inventory[i] = null
			
			#save_inventory()
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
	item_instance.z_index = -1
	print(item_instance.z_index)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	#save_inventory()
	
#adiciona o item a hot bar
func add_hotbar_item(item):
	for i in range(hotbar.size()):
		if hotbar[i] == null:
			item["isAssingned"] = true
			hotbar[i] = item
			#save_inventory()
			return true
	return false

#remove o item da hotbar
func remove_hotbar_item(item_type, item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			if hotbar[i]["quantity"] <= 0:
				hotbar[i] = null
				#save_inventory()
			inventory_updated.emit()
			return true
	return false

#coloca o item de volta ao inventario
func unnassign_hotbar_item(item_type, item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			hotbar[i] = null
			#save_inventory()
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
	#save_inventory()
	inventory_updated.emit()
	return true
	
func swap_hotbar_item(index1, index2):
	if index1 < 0 or index1 > hotbar.size() or index2 < 0 or index2 > hotbar.size():
		return false
		
	var temp = hotbar[index1]
	hotbar[index1] = hotbar[index2]
	hotbar[index2] = temp
	#save_inventory()
	inventory_updated.emit()
	return true

func find_item(item_name: String):
	var found_items = inventory.filter(func(item): return item != null and item.get("name") == item_name)
	var _item
	
	if found_items.size() > 0:
		_item = found_items[0]
	return _item
