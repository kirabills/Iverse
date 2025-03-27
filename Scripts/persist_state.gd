extends Node

# Caminho do arquivo de salvamento
const SAVE_FILE_PATH = "user://persistent_data.save"

# Salva o estado de um objeto
func save_state(object_name: String, state) -> void:
	var data = {}

	# Carrega os dados existentes, se o arquivo existir
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var files = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if files:
			data = files.get_var()
			files.close()
		else:
			print("Erro ao abrir o arquivo de salvamento para leitura.")
			return

	# Atualiza os dados com o estado atual do objeto
	data[object_name] = state

	# Salva os dados atualizados no arquivo
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()
		print("Estado do objeto '", object_name, "' salvo com sucesso.")
	else:
		print("Erro ao abrir o arquivo de salvamento para escrita.")

# Carrega o estado de um objeto
func load_state(object_name: String):
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Arquivo de salvamento não encontrado.")
		return null

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		print("Erro ao abrir o arquivo de salvamento.")
		return null

	var data = file.get_var()
	file.close()

	if not data is Dictionary:
		print("Dados de salvamento inválidos.")
		return null

	if data.has(object_name):
		print("Estado do objeto '", object_name, "' carregado: ", data[object_name])
		return data[object_name]
	else:
		print("Dados para o objeto '", object_name, "' não encontrados.")
		return null
