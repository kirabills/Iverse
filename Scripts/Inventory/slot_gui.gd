extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

var itemStackGui: ItemStackGui


func insert(isg: ItemStackGui) -> void:
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
