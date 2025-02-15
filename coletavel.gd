extends Area2D

@onready var sprite: Sprite2D = $Texture

@export_category("Textura")
@export var textura: Texture

func _ready() -> void:
	sprite.texture = textura

func _on_area_entered(area: Area2D) -> void:
	if area.name == "action":
		queue_free()
