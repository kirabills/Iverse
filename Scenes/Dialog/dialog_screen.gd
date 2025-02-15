extends Control
class_name  DialogScreen



var _step: float = 0.05

var _id: int = 0
var data: Dictionary = {}

@export_category("Obejetos")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

func _ready() -> void:
	initialize_dialog()
	
	
func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("OK") and _dialog.visible_ratio < 1:
		_step = 0.01
		return 
	_step = 0.05
	if Input.is_action_just_pressed("OK"):
		_id += 1
		if _id == data.size():
			queue_free()
			_global.isPressed = false
			_global.isControl = true
		
		
			return
		initialize_dialog()
	
func initialize_dialog() -> void:
	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])
	
	_dialog.visible_characters = 0
	_global.isControl = false
	
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1
	
	
	
	
