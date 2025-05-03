extends Area2D
class_name NPC
#const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")
@onready var quests: Area2D = $"../Quests"

@export_category("Dialogos")

	


@export_category("Objetos")
@export var _hud: CanvasLayer = null

var isComplete: bool = false

func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	if _global.isControl:
		_hud.inventory_hotbar.visible = true
		




func _on_body_entered(_body: Node2D) -> void:
	pass
