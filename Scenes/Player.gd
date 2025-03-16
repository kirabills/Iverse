extends CharacterBody2D
class_name Player

#variaves export
@export_category("Atributos Player")
@export var SPEED: int = 120
var life_max: int = 100
@export var Life_current: int = 100
var mana_max: int = 100
@export var mana_current: int = 100

@export_category("Objetcts")
@export var anim : AnimationPlayer
@export var player : Sprite2D

signal updatedHP
#onready variaveis

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
	if event.is_action_pressed("ui_select"):
		damage(3, 3)
	if event.is_action_pressed("heal"):
		heal(4, 2)

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
			manaHeal(3, 2)
		"Health":
			heal(3, 2)
		"Slot Plus":
			Inventory_g.increase_inventory_size(5)
		
		_:
			print("Este item nao tem efeito")

func isFull():
	return Life_current == life_max
	
func manaIsFull():
	return mana_current == mana_max

func heal(amount: int, multiplicador: int):
	if !isFull():
		Life_current += amount * multiplicador
		if Life_current > life_max: Life_current = life_max
		updatedHP.emit()
func heal_all():
	mana_current = mana_max
	Life_current = life_max

func heal_full(): Life_current = life_max

func mana_full(): mana_current = mana_max

func manaHeal(amount: int, multiplicador: int):
	if  !manaIsFull():
		mana_current += amount * multiplicador
		if mana_current > mana_max: mana_current = mana_max
		updatedHP.emit()
	else :
		print("Mana esta cheia: " + str(mana_current))

func damage(amount: int, multiplicador: int):
	
		Life_current -= amount * multiplicador
		if Life_current < amount:
			Life_current = 0
		print(Life_current)
		updatedHP.emit()
		

func _on_action_area_entered(_area: Area2D) -> void:
	#if area.has_method("collect"):
		pass
		
