extends Node2D
class_name Level

const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")

@export_category("Dialogos")
@export var _dialog_data: Dictionary = {

}


@export_category("Objetos")
@export var _hud: CanvasLayer = null
#@export var _player: CharacterBody2D = null

func  _ready() -> void:
	get_window().mode = Window.MODE_FULLSCREEN

func _dialogo() -> void:
	var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
	



#func _on_area_2d_area_entered(area):
#	print(area)
#	if area == _player.get_collision_layer_value(1):
#		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
#		_new_dialog.data = _dialog_data
#		_hud.add_child(_new_dialog)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _on_inventory_gui_opened():
	get_tree().paused = true


func _on_inventory_gui_closed():
	get_tree().paused = false
