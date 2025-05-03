extends NPC

@export_file("*.json") var dialog_file: String
@export var quest_name: String
@export var item_name: String
@export var reward_name: String

var dialog_texts: Dictionary
var isActive := false
var hasIntroduced := false
var title := "NPC"

func _ready() -> void:
	if not dialog_file.is_empty():
		load_dialog_data()

	var saved_state = PersistState.load_state(name)
	if saved_state is Dictionary:
		isComplete = saved_state.get("isComplete", false)
		hasIntroduced = saved_state.get("hasIntroduced", false)
	elif saved_state != null:
		isComplete = saved_state  # compatibilidade com estados antigos

func _exit_tree() -> void:
	save_state()

func save_state() -> void:
	PersistState.save_state(name, {
		"isComplete": isComplete,
		"hasIntroduced": hasIntroduced
	})

func load_dialog_data() -> void:
	var file = FileAccess.open(dialog_file, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY:
			dialog_texts = data
			title = data.get("title", "NPC")
		else:
			push_warning("Formato de JSON inválido.")
	else:
		push_error("Erro ao abrir arquivo de diálogo: " + dialog_file)

func _on_body_entered(_body: Node2D) -> void:
	if not _body.is_in_group("player"):
		return

	if isComplete and not isActive:
		show_dialog_sequence("thank_you")
		return

	if Inventory_g.find_item(item_name) and isActive and not isComplete:
		entregar_item()
		return

	if not isComplete and not isActive:
		if not hasIntroduced:
			show_dialog_sequence("intro")
			hasIntroduced = true
			
			save_state()
			return
		else:
			iniciar_quest()
			return

	show_dialog_sequence("quest")

func iniciar_quest() -> void:
	if _global.list_quest.find(quest_name) < 0:
		_global.list_quest.append(quest_name)
		_global.updateList.emit("add", quest_name)
	isActive = true
	show_dialog_sequence("quest")

func entregar_item() -> void:
	var dialog = replace_tokens_in_list(dialog_texts.get("complete", []))
	var reward_text = "Você ganhou: " + quests.item_named()
	dialog.append(reward_text)

	_global.list_quest.erase(quest_name)
	quests.verify_complete()
	isComplete = true
	isActive = false
	save_state()
	_global.updateList.emit("remove", quest_name)

	show_dialog_sequence_from_list(dialog)

func show_dialog_sequence(key: String) -> void:
	var text_list = dialog_texts.get(key, [])
	text_list = replace_tokens_in_list(text_list)
	show_dialog_sequence_from_list(text_list)

func show_dialog_sequence_from_list(text_list: Array) -> void:
	var dialog_data := {}
	for i in text_list.size():
		dialog_data[i] = {
			"title": title,
			"dialog": text_list[i]
		}
	ativa_dialog(dialog_data)

func replace_tokens_in_list(list: Array) -> Array:
	var output := []
	for line in list:
		output.append(line.replace("{item}", item_name))
	return output

func ativa_dialog(data: Dictionary) -> void:
	var _new_dialog: DialogScreen = _global._DIALOG_SCREEN.instantiate()
	_new_dialog.data = data
	_hud.add_child(_new_dialog)
	_hud.inventory_hotbar.visible = false
	_global.isPressed = true
