extends Node
var isPressed: bool = false
var isControl: bool = true

const _DIALOG_SCREEN: PackedScene = preload("res://Scenes/Dialog/dialog_screen.tscn")
var save_path = "user://save.dat"

var save_dict: Dictionary = {
	#salva atributos do player
		"player_health": 100,
		"player_mana": 100,
		"player_position": Vector2(27, 100),
		"isInterior": false,
		
		#salva a hora e dia
		"day": 1,
		"hour": 6,
		"minute": 0,
		"seconds": 0,
		"current_state_day": 0
	}
	
var list_quest: Array = []

@warning_ignore("unused_signal")
signal updateList(type: String)

func _ready() -> void:
	if not FileAccess.file_exists(save_path):
		save()
	else: load_data()

func save():

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()
	Inventory_g.save_inventory()
	
func load_data():
	if not FileAccess.file_exists(save_path): return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	save_dict = file.get_var()
	Inventory_g.load_inventory()
	file.close()

#var dia: Node
#var hour: int = 6
#var minute: int = 0
