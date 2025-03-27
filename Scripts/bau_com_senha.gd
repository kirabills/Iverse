extends StaticBody2D

class_name BAU
var playlist: Array = [
	load("res://Assets/Ninja Adventure - Asset Pack/Sounds/Game/GameOver2.wav"),
	load("res://Assets/Ninja Adventure - Asset Pack/Sounds/Game/Success1.wav")
]
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export_category("Objects")
@export var animate: AnimatedSprite2D = null
@export var campo_pass: LineEdit = null
@export var item: PackedScene = null


@export_category("Variables")
@export var password: String = ""

@export var isOpen: bool = false

func _ready() -> void:
	# Carrega o estado do baú ao iniciar
	var saved_state = PersistState.load_state(name)
	
	if saved_state != null:
		isOpen = saved_state
	if animate and campo_pass:
		if isOpen:
			animate.frame = 4
			campo_pass.visible = false
		else:
			animate.frame = 0

func _on_button_pressed() -> void:
	verify_password()
		
func verify_password() -> void:
	if campo_pass and campo_pass.text == password and !isOpen and item and Inventory_g.player_node:
		audio.stream = playlist[1]
		audio.play(0)
		var instance = item.instantiate()
		instance.global_position = Inventory_g.player_node.global_position + Vector2(10, 15)
		if animate:
			animate.play("open")
		campo_pass.visible = false
		_global.isControl = true
		await animate.animation_finished
		get_parent().add_child(instance)
		isOpen = true
		# Salva o estado do baú
		PersistState.save_state(name, isOpen)
	else:
		var cor_origin = campo_pass.modulate
		audio.stream = playlist[0]
		audio.play(0)
		campo_pass.modulate = Color(1, 0, 0)
		await  get_tree().create_timer(0.5).timeout
		campo_pass.modulate = cor_origin
		

		

func _on_button_2_pressed() -> void:
	campo_pass.visible = false
	_global.isControl = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !isOpen:
			campo_pass.visible = true
			_global.isControl = false
		


func _on_line_edit_text_submitted(_new_text: String) -> void:
	verify_password()
