@tool
extends Node2D

@export_category("Detalhes do Item")
@export var item_type: String
@export var item_name: String
@export var item_texture: Texture
@export var item_effect: String
var scene_path = "res://Scenes/Prefabs/inventory_item.tscn"

#Referencias de no na arvore
@onready var icon_sprite = $Sprite2D

var player_in_range: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if player_in_range and Input.is_action_just_pressed("ui_add"):
		pickup_item()
func pickup_item() -> void:
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"scene_path" : scene_path,
	}
	if Inventory_g.player_node:
		Inventory_g.add_item(item)
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pickup_item()
		self.queue_free()
	#if body.is_in_group("player"):
		#player_in_range = true
		#body.interact_ui.visible = true



func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]

func initiate_items(type, names , effect , texture):
	item_type = type 
	item_name = names
	item_effect = effect
	item_texture = texture
