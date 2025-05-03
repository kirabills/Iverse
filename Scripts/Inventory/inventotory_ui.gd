#ui inventory.gd
extends Control
@onready var grid_container = $GridContainer
@onready var assign_button: Button= $UsagePanel/AssignButton
@onready var drop_button : Button = $UsagePanel/DropButton
@onready var usage_panel: NinePatchRect = $UsagePanel

var dragged_slot = null
var temp_slot_position 


func _ready() -> void:
	Inventory_g.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	
func _process(_delta: float) -> void:
	if dragged_slot != null:
		dragged_slot.icon.global_position = get_global_mouse_position()
		drop_button.disabled = false
		assign_button.disabled = false
		usage_panel.visible = true
	else:
		assign_button.text = "Equipar"
		drop_button.disabled = true
		assign_button.disabled = true
		usage_panel.visible = false
		
	
func _on_inventory_updated():
	clear_grid_container()
	
	for item in Inventory_g.inventory:
		var slot = Inventory_g.inventory_slot_scene.instantiate()
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
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
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if dragged_slot != null:
			if drop_button.is_hovered():
				dragged_slot.drop()
			if assign_button.is_hovered():
				dragged_slot.assign_item_in_hot_bar()
				
			

#Armazena a referencia do dragged slot
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	temp_slot_position = dragged_slot.icon.global_position
	dragged_slot.icon.global_position = get_global_mouse_position()
	dragged_slot.background.frame = 0
	dragged_slot.quantity_label.visible = false
	if dragged_slot.isAssingned:
		assign_button.text = "Desequipar"
	else:
		assign_button.text = "Equipar"
	#print("Drag iniciado por slot: " + str(dragged_slot))
	
func _on_drag_end():
	var target_slot = get_slot_under_mouse()  # Obtém o slot sob o mouse
	if target_slot == dragged_slot and dragged_slot != null:
		# Restaura a posição do ícone e encerra a operação
		dragged_slot.icon.global_position = temp_slot_position
		dragged_slot.background.frame = 1
		dragged_slot.quantity_label.visible = true
		dragged_slot = null
		return  # Sai da função sem fazer mais nada
	# Verifica se há um slot de destino e se ele contém um item
	if target_slot and target_slot.item != null:
		# Verifica se os itens são do mesmo tipo (comparando IDs, por exemplo)
		if target_slot.item["name"] == dragged_slot.item["name"]:
			# Combina as quantidades dos itens
			var max_amount = target_slot.item["amount"] 
			var total_amount = target_slot.item["quantity"] + dragged_slot.item["quantity"]
			print(total_amount)
			if target_slot.item["quantity"] == max_amount:
				drop_slot(dragged_slot, target_slot)
				return
			if total_amount <= max_amount:
				target_slot.item["quantity"] = total_amount
				dragged_slot.item["quantity"] = total_amount - max_amount
				Inventory_g.remove_specific_item(dragged_slot.item)
				_on_inventory_updated()
			else:
				target_slot.item["quantity"] = max_amount
				dragged_slot.item["quantity"] = total_amount - max_amount
				
			# Esvazia o slot arrastado
			#Inventory_g.remove_item(dragged_slot.item["type"], dragged_slot.item["effect"])
			_on_inventory_updated()
		else:
			# Se os itens forem diferentes, troca os itens de lugar
			drop_slot(dragged_slot, target_slot)
	elif target_slot:
		# Se o slot de destino estiver vazio, move o item para ele
		drop_slot(dragged_slot, target_slot)
	# Restaura a posição do ícone arrastado
	if dragged_slot:
		dragged_slot.icon.global_position = temp_slot_position
		dragged_slot.background.frame = 1
		dragged_slot.quantity_label.visible = true
		dragged_slot = null
	
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
			return i
	return -1
	
func drop_slot(slot_1: Control, slot_2: Control):
	var slot1_index = get_slot_index(slot_1)
	var slot2_index = get_slot_index(slot_2)
	if slot1_index == -1 or slot2_index == -1:
		print("Slot invalido ou nao econtrado")
		return
	else:
		if Inventory_g.swap_inventory_item(slot1_index, slot2_index):
			_on_inventory_updated()
		else:
			_on_inventory_updated()
