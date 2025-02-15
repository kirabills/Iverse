extends CharacterBody2D
class_name Player

@export_category("Atributos Player")
@export var SPEED = 120
@export var invert = false

@export_category("Objetcts")
@export var anim : AnimationPlayer
@export var player : Sprite2D
@export var inventory: Inventory

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):
	# Adiciona gravidade se o personagem não estiver no chão

	# Captura a direção do movimento
	var direction = Vector2.ZERO
	if _global.isControl:
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")

	# Normaliza a direção para evitar velocidades inconsistentes
	if direction.length() > 0:
		direction = direction.normalized() * SPEED
		anim_p(direction)
	else:
		anim_p(Vector2.ZERO)

	velocity = direction
	move_and_slide()

func anim_p(direction):
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			anim.play("Walk")
			player.flip_h = direction.x < 0
		#elif direction.y < 0:
			#anim.play("Walk_Up")
		#else:
			#anim.play("Walk_Down")
	else:
		anim.play("Idle")

@onready var inv : coletavel
func _on_action_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)
