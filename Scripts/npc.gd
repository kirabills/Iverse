extends Area2D

const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")

@export_category("Dialogos")
@export var _dialog_data: Dictionary = {

}


@export_category("Objetos")
@export var _hud: CanvasLayer = null

func _on_body_entered(body):
	if body.name == "Player":
		if not _global.isPressed:
			var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
			_new_dialog.data = _dialog_data
			_hud.add_child(_new_dialog)
			
			
				
		_global.isPressed = true
		
