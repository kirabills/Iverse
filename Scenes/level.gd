extends Node2D
class_name Level


@onready var items: Node2D = $Items
@onready var item_spawn_area: Area2D = $ItemSpawnArea
@onready var collision_shape: CollisionShape2D = $ItemSpawnArea/CollisionShape2D


#@export var _player: CharacterBody2D = null

func  _ready() -> void:
	get_window().mode = Window.MODE_FULLSCREEN
	spawn_random_items(10)

func get_random_position() -> Vector2:
	var area_rect = collision_shape.shape.get_rect()
	var x = randf_range(0, area_rect.position.x)
	var y = randf_range(0, area_rect.position.y)
	return item_spawn_area.to_global(Vector2(x, y))

func spawn_random_items(count):
	var attempts: int = 0
	var spawned_count: int = 0
	while  spawned_count < count and attempts < 100:
		var positionn = get_random_position()
		spawn_item(Inventory_g.spawnable_items[randi() % Inventory_g.spawnable_items.size()], positionn)
		spawned_count += 1
		attempts += 1
		
func spawn_item(data, positionn):
	var item_scene = preload("res://Scenes/Prefabs/inventory_item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"])
	item_instance.global_position = positionn
	items.add_child(item_instance)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _on_inventory_gui_opened():
	get_tree().paused = true


func _on_inventory_gui_closed():
	get_tree().paused = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage(3 , 2)
