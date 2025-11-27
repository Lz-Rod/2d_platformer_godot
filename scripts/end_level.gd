extends Area2D

@export var next_level = ""

#aqui troca a fase no momento que o player encosta no objeto do level ending
func _on_body_entered(_body: Node2D) -> void:
	call_deferred("load_next_scene")

func load_next_scene():
	get_tree().change_scene_to_file("res://scene/" + next_level + ".tscn")
