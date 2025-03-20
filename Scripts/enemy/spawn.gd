extends Marker2D
class_name Spawn

@export var enemy: Array[PackedScene] = [null]
@export var count_spawn: int = 5  # Número máximo de slimes a serem spawnados
@export var spawn_interval: float = 5  # Intervalo de tempo entre spawns


var count = 0  # Contador de slimes spawnados

func _ready() -> void:
	# Configura o timer para spawnar slimes
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func spawn() -> void:
	if count < count_spawn and enemy.size() > 0 and enemy[0] != null:
		var enemy_instance = enemy[0].instantiate()
		var offset_x = randf_range(0, 250)  # Valores entre -250 e 250
		var offset_y = randf_range(0, 250)  # Valores entre -250 e 250
		enemy_instance.global_position = global_position + Vector2(offset_x, offset_y)
		enemy_instance.set_idle(5)
		# Adiciona o slime à cena e ao grupo "slimes"
		get_parent().add_child(enemy_instance)
		
		
		
		count += 1


func _on_timer_timeout() -> void:
	spawn()
