extends Camera2D

@export var player: CharacterBody2D

@export_category("Limites")
@export var limite_right: Marker2D

func _ready() -> void:
	self.limit_right = int(limite_right.position.x)

func _process(_delta: float) -> void:
	self.position.x = player.position.x
	self.position.y = player.position.y
