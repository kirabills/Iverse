extends "res://coletavel.gd"


@onready var animations: AnimationPlayer = $AnimationPlayer

func collect(inventory: Inventory) -> void:
	
	animations.play("spin")
	await  animations.animation_finished
	super(inventory)
