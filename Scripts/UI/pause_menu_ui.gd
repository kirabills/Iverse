extends TabContainer

var tema = Theme.new()

var tab_icons: Array = [
	load("res://Assets/UI/Icons_Essential/v1.2/Icons/Backpack.png"),
	load("res://Assets/UI/Icons_Essential/v1.2/Icons/Gear.png")
]



func _ready() -> void:
	set_tab_title(0, "")
	set_tab_icon(0, tab_icons[0])
	set_tab_title(1, "")
	set_tab_icon(1, tab_icons[1])
	
	


func _on_continue_pressed() -> void:
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible

func _on_sair_pressed() -> void:
	get_tree().quit()
