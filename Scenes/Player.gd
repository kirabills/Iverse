extends CharacterBody2D
class_name Player

#variaves export
@export_category("Atributos Player")
@export var SPEED = 120
@export var invert = false

@export_category("Objetcts")
@export var anim : AnimationPlayer
@export var player : Sprite2D


#onready variaveis
@onready var interact_ui: CanvasLayer = $InteractUI
@onready var inventory_ui: CanvasLayer = $InventoryUI
# variaveis mista
var olhando: String = ""

func _ready() -> void:
	Inventory_g.set_player_reference(self)

func _physics_process(_delta):


	# Captura a direção do movimento
	var direction = Vector2.ZERO
	if _global.isControl:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Normaliza a direção para evitar velocidades inconsistentes
	if direction.length() > 0:
		direction = direction.normalized() * SPEED
		anim_p(direction)
	else:
		anim_p(Vector2.ZERO)

	velocity = direction
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused

func anim_p(direction):
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			#anim.play("walk")
			player.flip_h = direction.x < 0
			if player.flip_h == true:
				olhando = "Left"
				anim.play("walk_left")
			elif player.flip_h == false:
				anim.play("walk")
				olhando = "Right"
				
		elif direction.y < 0:
			anim.play("walk_up")
			olhando = "UP"
		else:
			anim.play("walk_down")
			olhando = "Down"
	else:
		match olhando:
			"Left":
				anim.play("idle_left")
			"Right":
				anim.play("idle_right")
			"UP":
				anim.play("idle_up")
			"Down":
				anim.play("idle_down")
			

func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			SPEED += 50
			print("Speed increased to: ", SPEED)
		"Health":
			if $Health.max < 100:
				$Health.heal(3, 1)
		"Slot Plus":
			Inventory_g.increase_inventory_size(5)
		
		_:
			print("Este item nao tem efeito")

func _on_action_area_entered(_area: Area2D) -> void:
	#if area.has_method("collect"):
		pass
		
