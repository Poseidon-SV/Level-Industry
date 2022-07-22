extends Area2D


func _on_Ladder_body_entered(body):
	if body.name == "Player":
		get_node("../../../Player").Ladder = true
#"../../Player"
func _on_Ladder_body_exited(body):
	if body.name == "Player":
		get_node("../../../Player").Ladder = false
