extends Area2D
class_name Teleport




@export_category("tp")
@export var scene_path: PackedScene
@export_enum("Enter", "Exit") var state_door = "Enter"


var last_limit
var isInterior := false


	
		
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# 1. Para de monitorar colisões (evita retrigger)
		set_deferred("monitoring", false)
		
		# 2. Define a posição do jogador ANTES de trocar de cena
		if state_door != "Enter":
			_global.save_dict.player_position.y += 10
		
		# 3. Agenda a troca de cena para o próximo frame
		call_deferred("_change_scene")

func _change_scene():
	var target_scene = "res://Scenes/level.tscn" if state_door != "Enter" else scene_path.resource_path
	get_tree().change_scene_to_file(target_scene)
			
			
		
