extends Camera2D

@export var player: CharacterBody2D

@export_category("Limites")
@export var limite_right: Marker2D
@export var limite_left: Marker2D
@export var limite_up: Marker2D
@export var limite_down: Marker2D

func _ready() -> void:
	self.make_current()
	self.limit_right = int(limite_right.position.x)
	self.limit_left = int(limite_left.position.x)
	self.limit_top = int(limite_up.position.y)
	self.limit_bottom = int(limite_down.position.y)

func _process(_delta: float) -> void:
	self.position.x = player.position.x
	self.position.y = player.position.y
