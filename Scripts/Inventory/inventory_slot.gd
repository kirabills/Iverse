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

var itemHealhBlock: Array = [
	"Health",
	"Health Full",
]
var itemManaBlock: Array = [
	"Mana",
	"Mana Full",
]

var item = null
func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible = !usage_panel.visible
	

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

func _on_drop_button_pressed() -> void:
	if item != null:
		var drop_position = Inventory_g.player_node.global_position
		var drop_offset = Vector2(0 , 50)
		drop_offset = drop_offset.rotated( Inventory_g.player_node.rotation)
		Inventory_g.drop_item(item, drop_position + drop_offset)
		Inventory_g.remove_item(item["type"], item["effect"] )
		usage_panel.visible = false

func _on_use_button_pressed() -> void:
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if item["effect"] in itemHealhBlock  and  Inventory_g.player_node.isFull(): return
		if item["effect"] in itemManaBlock and Inventory_g.player_node.manaIsFull(): return
		if Inventory_g.player_node:
			Inventory_g.player_node.apply_item_effect(item)
			Inventory_g.remove_item(item["type"], item["effect"] )
		else:
			print("Player não encontrado")
