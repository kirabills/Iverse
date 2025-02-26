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


func _ready() -> void:
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
