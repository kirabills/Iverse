extends Node2D



@export_category("Tipo de Quest e Tipo de Recompensa")
@export_enum("Item", "NPC") var Quest = "Item"
@export_enum("Money", "Item", "Experiencia") var recompensas = "Item"
@export var NameQuest: String


@export_category("Quest de Items")
@export var item_name: String
@export var valor_requerido: int

@export_category("Quests_npc")
@export var npc_name: String

@export var text_quest: String
#@onready var namec: String = text_quest + " " + str(valor_requerido) + " " + item_name

@export_category("Variaveis de recompensa")
@export var item_reward: PackedScene = null
@export_range(1, 5) var item_quantidade: int = 1
@export var money_reward: int = 50
@export var exp_reward: int = 2

var isActive := false

#func _ready() -> void:
	#verify_complete()

func verify_complete():
	match Quest:
		"Item":
			var item = Inventory_g.find_item(item_name)
			if item == null: return
			if item["quantity"] >= valor_requerido:
				print("Voce completou a quest e ganhou: ", item_named())
				Inventory_g.remove_specific_item(item)
				reward()
		"NPC":
			print("e uma quest de npc")

func reward() -> void:
	match recompensas:
		"Item":
			Inventory_g.add_item_from_scene(item_reward, 
				item_quantidade, false)
			
		"Money":
			pass
			
		"Experiencia":
			pass

func item_named() -> String:
	var instance = item_reward.instantiate()
	var data = instance.get_item_data()
	var i_name: String = data["name"]
	instance.queue_free()
	return i_name


func _on_body_entered(_body: Node2D) -> void:
	pass
	#if body.is_in_group("player"):
		#verify_complete()
