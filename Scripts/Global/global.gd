extends Node
var isPressed: bool = false
var isControl: bool = true

const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")

var dia: Node
var hour: int = 6
var minute: int = 0


func get_dia(Dia: Node):
	dia = Dia
