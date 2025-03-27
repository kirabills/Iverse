extends Area2D

#const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")

@export_category("Dialogos")
@export var _dialog_data: Dictionary = {
	0: {
		"dialog": "teste",
		"title": "teste"
	}
}
	



@export_category("Objetos")
@export var _hud: CanvasLayer = null




func _process(_delta: float) -> void:
	if _global.isControl:
		_hud.inventory_hotbar.visible = true
		




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var _new_dialog: DialogScreen = _global._DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		print(_new_dialog.data)
		_hud.add_child(_new_dialog)
		_hud.inventory_hotbar.visible = false
		
		
		_global.isPressed = true
