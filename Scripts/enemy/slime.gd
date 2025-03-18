extends CharacterBody2D

var player = null
var isDead: bool = false

var _spawn

@export_category("Obejetos")
@export var texture : Sprite2D
@export var anim: AnimationPlayer
@export var drop_item: Array[PackedScene] = [null]

@export var dano: int = 1
@export var ranger: float = 200.0
func _ready() -> void:
	_spawn = get_node("/root/Level/Marker2D")
	
func  _process(_delta: float) -> void:
	anime()
	var distance = global_position.distance_to(Inventory_g.player_node.global_position)
	if distance < ranger:
		var speed = Inventory_g.player_node.Speed * 0.5 
		var direction = global_position.direction_to(Inventory_g.player_node.global_position)
		velocity = direction * speed
		
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()



func anime() -> void:
	if velocity.x > 0:
		texture.flip_h = false
	else:
		texture.flip_h = true
	
	if isDead:
		anim.play("dead")
		return
	if velocity != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
		
	
func drop() -> void:
	var rand =  randi() % 100
	print(rand)
	if rand >= 15 and rand <= 25:
	
		if drop_item == [null]:
			return
		var rand_index = randi() % drop_item.size()
		var item_instance = drop_item[rand_index].instantiate()
		
		item_instance.global_position = global_position
		get_parent().add_child(item_instance) 

func set_idle(damage: int):
	velocity = Vector2.ZERO
	isDead = false
	anim.play("idle")
	dano = damage

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		_spawn.count -= 1
		drop()
		self.queue_free()
