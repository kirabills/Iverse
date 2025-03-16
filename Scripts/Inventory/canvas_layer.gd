extends CanvasLayer

@onready var HP_BAR: TextureProgressBar = $ProgressHp
@onready var txt_hp: Label = $ProgressHp/txt_hp

func _ready() -> void:
	verify_os()
	Inventory_g.player_node.updatedHP.connect(update_bar)
	update_bar()

func verify_os():
	if OS.get_name() == "Android":
		$Mobile.visible = true
	else:
		$Mobile.visible = false

func update_bar():
	var hp = Inventory_g.player_node.Life_current * 100 / Inventory_g.player_node.life_max
	HP_BAR.value = hp
	txt_hp.text = str(hp) + "%"
