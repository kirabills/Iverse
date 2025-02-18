extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@export var amountLabel: Label

func _update(slot: InventorySlot) -> void:
	if !slot.item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amountLabel.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		itemSprite.scale.x = 2
		itemSprite.scale.y = 2
		if slot.amount > 1:
			amountLabel.visible = true
		amountLabel.text = str(slot.amount)
