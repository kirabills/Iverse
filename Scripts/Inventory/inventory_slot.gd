extends Control

@onready var icon: Sprite2D = $ItemButton/ItemIcon
@onready var background: Sprite2D = $ItemButton/BackGround
@onready var quantity_label: Label = $ItemButton/ItemQuantity
@onready var details_panel: ColorRect = $DetailsPanel
@onready var item_name: Label = $DetailsPanel/ItemName
@onready var item_type: Label = $DetailsPanel/ItemType
@onready var item_effect: Label = $DetailsPanel/ItemEffect
@onready var usage_panel: ColorRect = $UsagePanel
@onready var inventory_ui =  preload("res://Scenes/Prefabs/Inventotory_ui.tscn")
@onready var assignButton: Button = $UsagePanel/AssignButton
@onready var timer_long_press: Timer = $Timer_longPress


var slot_index : int = -1
var isHotbar: bool = false

var can_drag: bool = false

signal drag_start(slot)
signal drag_end()

var itemHealhBlock: Array = [
	"Health",
	"Health Full",
]
var itemManaBlock: Array = [
	"Mana",
	"Mana Full",
]

var item = null
var item_selected = null
var isAssingned: bool = false
#set index




func set_slot_index(new_index):
	slot_index = new_index



func _on_item_button_mouse_entered() -> void:
	
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false
	
	


func set_empty() -> void:
	icon.texture = null
	quantity_label.text = ""
	background.frame = 0
	
func isEmpty() -> bool:
	if item == null:
		return true
	return false
	
func set_item(new_item) -> void:
	item = new_item
	background.frame = 1
	icon.texture = new_item["texture"]
	icon.scale = Vector2(item["size_texture"], item["size_texture"])
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ " + item["effect"])
	else:
		item_type.text = ""
	update_assigment_status()

func _on_drop_button_pressed() -> void:
	drop()

func drop():
	if item != null:
		var drop_position = Inventory_g.player_node.global_position
		var drop_offset = Vector2(0 , 50)
		drop_offset = drop_offset.rotated( Inventory_g.player_node.rotation)
		Inventory_g.drop_item(item, drop_position + drop_offset)
		Inventory_g.remove_item(item["type"], item["effect"] )
		Inventory_g.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false
#func _on_use_button_pressed() -> void:
	#usage_panel.visible = false
	##if item != null and item["effect"] != "":
		##if item["effect"] in itemHealhBlock  and  Inventory_g.player_node.isFull(): return
		##if item["effect"] in itemManaBlock and Inventory_g.player_node.manaIsFull(): return
		##if Inventory_g.player_node:
			##Inventory_g.player_node.apply_item_effect(item)
			##Inventory_g.remove_item(item["type"], item["effect"] )
		##else:
			#print("Player não encontrado")

func update_assigment_status():
	isAssingned = Inventory_g.is_item_assign_to_hotbar(item)
	if isAssingned:
		assignButton.text = "Desvincular"
	else:
		assignButton.text = "Equipar"


func _on_assign_button_pressed() -> void:
	assign_item_in_hot_bar()
	
func assign_item_in_hot_bar():
	if item != null:
		if isAssingned:
			Inventory_g.unnassign_hotbar_item(item["type"], item["effect"])
			isAssingned = false
		else:
			Inventory_g.add_item(item, true)
			isAssingned = true
		update_assigment_status()

func use_hotbar_pressed():
	if item["effect"] in itemHealhBlock  and  Inventory_g.player_node.isFull(): return
	if item["effect"] in itemManaBlock and Inventory_g.player_node.manaIsFull(): return
	Inventory_g.player_node.apply_item_effect(item)
	item["quantity"] -= 1
	if item["quantity"] <= 0:
		Inventory_g.remove_item(item["type"], item["effect"])
		Inventory_g.remove_hotbar_item(item["type"], item["effect"])
		item = null
	Inventory_g.inventory_updated.emit()

#itemButtons pressed
func _on_item_button_gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.is_pressed():
					if !isEmpty() and !isHotbar:
						drag_start.emit(self)
				elif !isHotbar:
					drag_end.emit()
					
				if event.is_pressed():
					if isEmpty(): return
					timer_long_press.start(0.5)
					await timer_long_press.timeout
					if isHotbar and can_drag:
						drag_start.emit(self)
						
				elif isHotbar and can_drag:
					drag_end.emit()
				
				if event.is_released() and isHotbar:
					timer_long_press.stop()
					if !can_drag:
						use_hotbar_pressed()
					can_drag = false
			
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					if !isEmpty() and isHotbar:
						drag_start.emit(self)
				if event.is_released():
					if isHotbar:
						drag_end.emit()
	 
func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if $UsagePanel/DropButton.is_hovered():
			drop()
		if $UsagePanel/AssignButton.is_hovered():
			assign_item_in_hot_bar()


func _on_timer_long_press_timeout() -> void:
	can_drag = true
	print_debug("Pode Arrastar ", can_drag)
	
