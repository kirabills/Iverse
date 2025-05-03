extends CharacterBody2D
class_name Player

var state_machine
var is_attacking: bool = false
#variaves export
var life_max: int = 100
var mana_max: int = 100
@export_category("Atributos Player")
@export var Speed: int = 120
@export var friction: float = 0.2
@export var acceleration: float = 0.1
@export var Life_current: int = 100
@export var mana_current: int = 100

@export_category("Objetcts")
@export var anim : AnimationTree
@export var player : Sprite2D
@export var Attack_timer: Timer

signal updatedHP
#onready variaveis

# variaveis mista
var olhando: String = ""
var isCoolDown: bool = false

func _ready() -> void:
	Inventory_g.set_player_reference(self)
	state_machine = anim["parameters/playback"]
	anim.active = true
	load_atributos()
	updatedHP.emit()
	

func _physics_process(_delta):


	# Captura a direção do movimento
	move()
	attack()
	anim_p()
	move_and_slide()



func  move() -> void:
	
	var direction: Vector2
	
	if _global.isControl:
		direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
		)
	# Normaliza a direção para evitar velocidades inconsistentes
	if direction != Vector2.ZERO:
		anim["parameters/idle/blend_position"] = direction
		anim["parameters/walk/blend_position"] = direction
		anim["parameters/attack/blend_position"] = direction
		velocity.x = lerp(velocity.x, direction.normalized().x * Speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * Speed, acceleration)
		return
	velocity.x = lerp(velocity.x, direction.normalized().x * Speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * Speed, friction)
		
		
func attack() -> void:
	if Input.is_action_just_pressed("attack") and !is_attacking:
		Attack_timer.start()
		set_physics_process(false)
		is_attacking = true
		cost_mana(3, 2)
		
	
	
func anim_p():
	if is_attacking:
		state_machine.travel("attack")
		return
	if velocity.length() > 10:
		state_machine.travel("walk")
		return
	state_machine.travel("idle")

func apply_item_effect(item):
	match item["effect"]:
		"Mana":
			manaHeal(3, 2)
		"Mana Full":
			if !manaIsFull():
				mana_full()
		"Health":
			heal(3, 2)
		"Health Full":
			if !isFull():
				heal_full()
		"Cura Tudo":
			if !isFull() or !manaIsFull():
				heal_all()
		"Slot Plus":
			Inventory_g.increase_inventory_size(5)
		
		_:
			print("Este item nao tem efeito")

func isFull() -> bool:
	return Life_current == life_max
	
func manaIsFull() -> bool:
	return mana_current == mana_max

func heal(amount: int, multiplicador: int):
	if !isFull():
		Life_current += amount * multiplicador
		if Life_current > life_max: Life_current = life_max
		_global.save_dict.player_health = Life_current
		_global.save()
		updatedHP.emit()
func heal_all():
	mana_current = mana_max
	Life_current = life_max
	_global.save_dict.player_health = Life_current
	_global.save()
	updatedHP.emit()
func heal_full(): 
	Life_current = life_max
	_global.save_dict.player_health = Life_current
	_global.save()
	updatedHP.emit()
	

func mana_full():
	mana_current = mana_max; updatedHP.emit()
	_global.save_dict.player_mana = mana_current
	_global.save()

func manaHeal(amount: int, multiplicador: int):
	if  !manaIsFull():
		mana_current += amount * multiplicador
		if mana_current > mana_max: mana_current = mana_max
		_global.save_dict.player_mana = mana_current
		_global.save()
		updatedHP.emit()
	else :
		print("Mana esta cheia: " + str(mana_current))

func damage(amount: int, multiplicador: int):
	
		Life_current -= amount * multiplicador
		if Life_current < amount:
			Life_current = 0
		_global.save_dict.player_health = Life_current
		_global.save()
		updatedHP.emit()
		isCoolDown = true
		await get_tree().create_timer(1).timeout
		isCoolDown = false
		
		
func cost_mana(amount: int, multiplicador: int) -> void:
	mana_current -= amount * multiplicador
	if mana_current < amount: mana_current = 0
	_global.save_dict.player_mana = mana_current
	_global.save()
	updatedHP.emit()

func _on_action_area_entered(_area: Area2D) -> void:
	#if area.has_method("collect"):
		pass
		


func _on_hurt_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and !body.isDead:
		if !isCoolDown:
			damage(body.dano, 1)
			
			


func _on_attack_timer_timeout() -> void:
	is_attacking = false 
	set_physics_process(true)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.isDead = true

func use_hotbar_item(slot_index):
	if slot_index < Inventory_g.hotbar.size():
		var item = Inventory_g.hotbar[slot_index]
		if item != null:
			apply_item_effect(item)
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Inventory_g.hotbar[slot_index] = null
				Inventory_g.remove_item(item["type"], item["effect"])
		Inventory_g.inventory_updated.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		for i in range(Inventory_g.hotbar_size ):
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break
				


func load_atributos():
	Life_current = _global.save_dict.player_health
	mana_current = _global.save_dict.player_mana
