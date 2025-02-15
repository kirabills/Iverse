extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item


func _update(item: InventoryItem) -> void:
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
		itemSprite.scale.x = 2
		itemSprite.scale.y = 2
