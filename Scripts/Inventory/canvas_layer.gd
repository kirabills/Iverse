extends CanvasLayer

@onready var HP_BAR: TextureProgressBar = $ProgressHp
@onready var txt_hp: Label = $ProgressHp/txt_hp
@onready var MANA_BAR: TextureProgressBar = $ProgressMana
@onready var txt_mana: Label = $ProgressMana/txt_mana
@onready var pause_menu: TabContainer = $PauseMenu
@onready var inventory_hotbar = $HotBar/InventoryHorBar
@onready var item_list: ItemList = $PauseMenu/Quests/ItemList

var paused = null

@export var Mobile: Array[Node] = [null]


func _ready() -> void:
	verify_os()
	Inventory_g.player_node.updatedHP.connect(update_bar)
	_global.updateList.connect(update_list)
	update_bar()

func update_list(type: String, item_name := "") -> void:
	if type == "add":
		for i in _global.list_quest:
			item_list.add_item(i)
	elif type == "remove":
		if item_name != "":
			var index = get_index_item(item_name)
			print(item_name)
			if index >= 0:
				item_list.remove_item(index)
				print("eu entrei para remover", item_name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		pause_menu.visible = !pause_menu.visible
		inventory_hotbar.visible = !inventory_hotbar.visible
		_global.isControl = !_global.isControl
		get_tree().paused = !get_tree().paused
		
		

func verify_os(): 
	if OS.get_name() == "Android":
		for i in Mobile.size():
			Mobile[i].visible = true
			return
	for i in Mobile.size():
		Mobile[i].visible = false

func update_bar():
	var hp = Inventory_g.player_node.Life_current * 100 / Inventory_g.player_node.life_max
	var mana = Inventory_g.player_node.mana_current * 100 / Inventory_g.player_node.mana_max
	#life bar
	HP_BAR.value = hp
	txt_hp.text = str(hp) + "%"
	#mana bar
	MANA_BAR.value = mana
	txt_mana.text = str(mana) + "%"

func get_index_item(text: String) -> int:
	for i in item_list.item_count:
		if item_list.get_item_text(i) == text:
			return i
	return -1  # não encontrado
