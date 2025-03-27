extends CanvasLayer

@onready var HP_BAR: TextureProgressBar = $ProgressHp
@onready var txt_hp: Label = $ProgressHp/txt_hp
@onready var MANA_BAR: TextureProgressBar = $ProgressMana
@onready var txt_mana: Label = $ProgressMana/txt_mana
@onready var inventory_ui: CanvasLayer = $InventoryUI
@onready var inventory_hotbar = $HotBar/InventoryHorBar
var paused = null

@export var Mobile: Array[Node] = [null]


func _ready() -> void:
	verify_os()
	Inventory_g.player_node.updatedHP.connect(update_bar)
	update_bar()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
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
