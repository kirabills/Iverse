extends Control
@onready var hotbar_container: HBoxContainer = $HBoxContainer

var dragged_slot = null
var temp_slot_position 

func _ready() -> void:
	Inventory_g.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

func _process(_delta: float) -> void:
	if dragged_slot != null:
		dragged_slot.icon.global_position = get_global_mouse_position()

func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(Inventory_g.hotbar_size):
		var slot = Inventory_g.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		slot.isHotbar = true
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
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
		
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	temp_slot_position = dragged_slot.icon.global_position
	dragged_slot.icon.global_position = get_global_mouse_position()
	dragged_slot.background.frame = 0
	dragged_slot.quantity_label.visible = false
	
	
	#print("Drag iniciado por slot: " + str(dragged_slot))
	
func _on_drag_end():
	var target_slot = get_slot_under_mouse()  # Obtém o slot sob o mouse
	if target_slot == dragged_slot and dragged_slot != null and dragged_slot.isHotbar:
		# Restaura a posição do ícone e encerra a operação
		dragged_slot.icon.global_position = temp_slot_position
		dragged_slot.background.frame = 1
		dragged_slot.quantity_label.visible = true
		dragged_slot = null
		return  # Sai da função sem fazer mais nada
	# Verifica se há um slot de destino e se ele contém um item
	if target_slot and target_slot.item != null:
		# Verifica se os itens são do mesmo tipo (comparando IDs, por exemplo)
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
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot: Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot:
			return i
	return -1
	
func drop_slot(slot_1: Control, slot_2: Control):
	var slot1_index = get_slot_index(slot_1)
	var slot2_index = get_slot_index(slot_2)
	if slot1_index == -1 or slot2_index == -1:
		print("Slot invalido ou nao econtrado")
		return
	else:
		if Inventory_g.swap_hotbar_item(slot1_index, slot2_index):
			_update_hotbar_ui()
		
