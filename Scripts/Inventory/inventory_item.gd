extends Node2D

class_name InventoryItem

@export_category("Detalhes do Item")
@export var item_type: String
@export var item_name: String
@export var item_texture: String
@export var item_effect: String
@export var item_amount: int
@export var size: float
var scene_path = "res://Scenes/Prefabs/inventory_item.tscn"
var isAssingned: bool = false


#Referencias de no na arvore
@onready var icon_sprite = $Sprite2D
@onready var interact: TextureButton = $BtnPegarItem

var player_in_range: bool = false


	
func pickup_item() -> void:
	var item = {
		"quantity" : 1,
		"amount": item_amount,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"scene_path" : scene_path,
		"size_texture": size,
		"isAssingned": isAssingned,
	}
	if Inventory_g.player_node:
		Inventory_g.add_item(item, false)
		
func get_item_data() -> Dictionary:
	return {
		"quantity" : 1,
		"amount": item_amount,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"scene_path" : scene_path,
		"size_texture": size,
		"isAssingned": false,
	}
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		interact.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		interact.visible = false
		
func _on_btn_pegar_item_pressed() -> void:
	if player_in_range:
		pickup_item()
		self.queue_free()

func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
	size = data["size_texture"]
	item_amount = data["amount"]
	$Sprite2D.texture = load(item_texture)


func initiate_items(type, names , effect , texture):
	item_type = type 
	item_name = names
	item_effect = effect
	item_texture = texture
